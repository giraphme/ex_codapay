defmodule ExCodapay.Config.Validation do
  def validate(%ExCodapay.Config{} = config) do
    config
    |> make_changeset()
    |> validate_api_key()
    |> validate_country()
    |> validate_language()
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
end
