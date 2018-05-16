defmodule ExCodapay.Request do
  defstruct ~w(config order_id merchant_name msisdn email type pay_type pay_channel items)a

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

  def prepare(_, attrs) do
    {:error, "Arguments are missing (#{inspect(attrs)})"}
  end

  def send!(request, pay_type, args \\ []) do
    {:ok, response} = send(request, pay_type, args)
    response
  end

  def send(request, pay_type, args \\ [])

  @pay_type 1
  def send(%__MODULE__{} = _request, :direct_carrier_billing, _args) do
    raise ArgumentError, "Unsupported"
  end

  @pay_type 2
  def send(%__MODULE__{} = request, :bank_transfer, pay_channel: pay_channel)
      when is_integer(pay_channel) do
    request
    |> put_pay_type(@pay_type)
    |> put_pay_channel(pay_channel)
    |> ExCodapay.API.call()
  end

  @pay_type 3
  def send(%__MODULE__{} = request, :otc_payment, pay_channel: pay_channel)
      when is_integer(pay_channel) do
    request
    |> put_pay_type(@pay_type)
    |> put_pay_channel(pay_channel)
    |> ExCodapay.API.call()
  end

  def to_json(%__MODULE__{} = request) do
    request
    |> Map.from_struct()
    |> Map.take(~w(order_id merchant_name msisdn email type pay_type pay_channel)a)
    |> Map.merge(%{
      api_key: request.config.api_key,
      lang: request.config.language,
      items:
        request.items
        |> Enum.map(fn
          %ExCodapay.Item{} = item -> ExCodapay.Item.to_map_for_json(item) |> IO.inspect()
          item -> item
        end)
    })
    |> Jason.encode!()
  end

  defp put_pay_type(%ExCodapay.Request{} = request, pay_type) do
    put_in(request.pay_type, pay_type)
  end

  defp put_pay_channel(%ExCodapay.Request{} = request, bank_id) do
    put_in(request.pay_channel, bank_id)
  end
end
