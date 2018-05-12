defmodule ExCodapay.Config do
  defstruct ~w(api_key country language sandbox_mode)a

  def new!(overrides \\ []) do
    {:ok, config} = new(overrides)
    config
  end

  def new(overrides \\ []) do
    struct(__MODULE__, build_params(overrides))
    |> ExCodapay.Config.Validation.validate()
  end

  @sandbox_url "https://sandbox.codapayments.com/airtime/offline/charge/v2"
  @production_url "https://airtime.codapayments.com/airtime/offline/charge/v2"
  def base_url(%__MODULE__{sandbox_mode: true}), do: @sandbox_url
  def base_url(%__MODULE__{sandbox_mode: false}), do: @production_url

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
  end

  defp defaults do
    [
      api_key: {:system, "CODAPAY_API_KEY"},
      country: :indonesia,
      language: :in,
      sandbox_mode: true
    ]
  end

  defp assign_system_env({key, {:system, env_name}}) do
    {key, System.get_env(env_name)}
  end

  defp assign_system_env({key, value}) do
    {key, value}
  end
end
