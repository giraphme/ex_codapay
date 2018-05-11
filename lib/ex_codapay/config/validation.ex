defmodule ExCodapay.Config.Validation do
  def validate(%ExCodapay.Config{} = config) do
    config
    |> make_changeset()
    |> validate_api_key()
    |> validate_country()
    |> validate_language()
    |> validate_pay_types()
    |> validate_pay_channels()
    |> take_config_from_changeset()
  end

  defp make_changeset(%ExCodapay.Config{} = config), do: %{data: config, errors: []}
  defp take_config_from_changeset(%{data: config, errors: []}), do: {:ok, config}
  defp take_config_from_changeset(%{data: _, errors: e}), do: {:error, List.first(e)}
  defp add_error(changeset, error), do: Map.update!(changeset, :errors, &(&1 ++ [error]))

  defp validate_api_key(%{data: %{api_key: api_key}} = changeset) do
    cond do
      is_nil(api_key) -> add_error(changeset, "Can't find api_key")
      true -> changeset
    end
  end

  @valid_countries ~w(indonesia)a
  defp validate_country(%{data: %{country: country}} = changeset) do
    cond do
      is_nil(country) -> add_error(changeset, "Can't find country")
      country not in @valid_countries -> add_error(changeset, "Unsupported country")
      true -> changeset
    end
  end

  defp validate_language(%{data: %{country: country, language: language}} = changeset) do
    cond do
      country == :indonesia -> language in ~w(en in)a
      true -> false
    end
    |> case do
      true -> changeset
      false -> add_error(changeset, "Unsupported language in #{country}")
    end
  end

  @valid_pay_types ~w(direct_carrier_billing bank otc vr)a
  defp validate_pay_types(%{data: %{pay_types: pay_types}} = changeset) do
    cond do
      is_nil(pay_types) ->
        add_error(changeset, "Can't find pay_types")

      length(pay_types -- @valid_pay_types) > 0 ->
        add_error(changeset, "Has unsupported pay_type")

      true ->
        changeset
    end
  end

  defp validate_pay_channels(
         %{data: %{country: country, pay_types: pay_types, pay_channels: pay_channels}} =
           changeset
       ) do
    changeset
  end
end
