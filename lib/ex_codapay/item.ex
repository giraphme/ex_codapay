defmodule ExCodapay.Item do
  defstruct [:code, :name, :price, :type]

  def to_map_for_json(%__MODULE__{type: nil} = this) do
    %{
      "code" => this.code,
      "name" => this.name,
      "price" => this.price
    }
  end

  def to_map_for_json(%__MODULE__{} = this) do
    %{
      "code" => this.code,
      "name" => this.name,
      "price" => this.price,
      "type" => this.type
    }
  end
end
