defmodule ExCodapay.Config do
  defstruct ~w(api_key country language pay_types pay_channels sandbox_mode)a

  def new(overrides \\ []) do
    struct(__MODULE__, build_params(overrides))
    |> ExCodapay.Config.Validation.validate()
  end

  defp build_params(overrides) do
    defaults()
    |> Enum.into(%{})
    |> Map.merge(
      (Application.get_all_env(:ex_codapay) || [])
      |> Enum.into(%{})
    )
    |> Map.merge(Enum.into(overrides, %{}))
    |> Enum.map(&assign_system_env/1)
    |> Enum.into(%{})
    |> convert_pay_channels_to_i()
  end

  defp defaults do
    [
      api_key: {:system, "CODAPAY_API_KEY"},
      country: :indonesia,
      language: :in,
      pay_types: nil,
      pay_channels: nil,
      sandbox_mode: true
    ]
  end

  defp assign_system_env({key, {:system, env_name}}) do
    {key, System.get_env(env_name)}
  end

  defp assign_system_env({key, value}) do
    {key, value}
  end

  defp convert_pay_channels_to_i(%{pay_channels: pay_channels} = params)
       when is_list(pay_channels) do
    pay_channels =
      Enum.map(pay_channels, fn
        pay_channel_number when is_integer(pay_channel_number) ->
          case ExCodapay.PayChannel.to_s(pay_channel_number) do
            nil -> raise ArgumentError, "Not found in valid list the `#{pay_channel_number}`"
            _ -> pay_channel_number
          end

        pay_channel when is_binary(pay_channel) ->
          case ExCodapay.PayChannel.to_i(pay_channel) do
            nil -> raise ArgumentError, "Not found in valid list the `#{pay_channel}`"
            pay_channel_number -> pay_channel_number
          end

        _ ->
          raise ArgumentError, "Not found in valid list"
      end)

    Map.put(params, :pay_channels, pay_channels)
  end

  defp convert_pay_channels_to_i(params) do
    params
  end
end
