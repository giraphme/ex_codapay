defmodule ExCodapay.CompletionCallback do
  defstruct ~w(txn_id order_id result_code total_price payment_type checksum)a

  def validate(%__MODULE__{} = this, %ExCodapay.Config{api_key: api_key}, order_id) do
    with :ok <- validate_result_code(this),
         :ok <- validate_checksum(this, api_key: api_key, order_id: order_id) do
      {:ok, this}
    end
  end

  def validate(%{} = params, config, order_id) do
    validate(
      %ExCodapay.CompletionCallback{
        txn_id: params["TxnId"],
        order_id: params["OrderId"],
        result_code: params["ResultCode"],
        total_price: params["TotalPrice"],
        payment_type: params["PaymentType"],
        checksum: params["Checksum"]
      },
      config,
      order_id
    )
  end

  defp validate_result_code(%__MODULE__{result_code: 0}), do: :ok
  defp validate_result_code(%__MODULE__{result_code: 1}), do: {:error, "Payment failed"}

  defp validate_checksum(
         %__MODULE__{checksum: checksum, txn_id: txn_id, result_code: result_code},
         api_key: api_key,
         order_id: order_id
       )
       when is_binary(checksum) and is_binary(api_key) and is_integer(txn_id) and
              is_binary(order_id) and is_integer(result_code) do
    seed = Enum.join([txn_id, api_key, order_id, result_code])
    Base.encode16(:crypto.hash(:md5, seed), case: :lower) == checksum
  end
end
