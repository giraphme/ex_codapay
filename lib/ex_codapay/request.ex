defmodule ExCodapay.Request do
  defstruct ~w(config order_id merchant_name msisdn email type items)a

  def prepare!(config, params) do
    {:ok, request} = prepare(config, params)
    request
  end

  def prepare(
        %ExCodapay.Config{} = config,
        [merchant_name: merchant_name, msisdn: msisdn, email: email, items: items] = params
      )
      when is_binary(merchant_name) and is_binary(msisdn) and is_binary(email) and is_list(items) do
    {:ok,
     struct(__MODULE__, %{
       config: config,
       order_id: params[:order_id] || UUID.uuid4(),
       merchant_name: merchant_name,
       msisdn: msisdn,
       email: email,
       items: items,
       type: 2
     })}
  end

  def prepare(_, _) do
    {:error, "Arguments are missing"}
  end
end
