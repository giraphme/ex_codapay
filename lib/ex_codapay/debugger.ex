defmodule ExCodapay.Debugger do
  def mock_completion_notification(%ExCodapay.Config{} = config, attrs) do
    do_mock_completion_notification(config, attrs[:txn_id], attrs[:order_id], attrs)
  end

  defp do_mock_completion_notification(config, txn_id, order_id, attrs)
       when is_list(attrs) and is_integer(txn_id) and is_binary(order_id) do
    mock = %{
      "TxnId" => txn_id,
      "OrderId" => order_id,
      "ResultCode" => attrs[:result_code] || 0,
      "TotalPrice" => attrs[:total_price] || 0,
      "PaymentType" => attrs[:payment_type] || 0
    }

    seed = Enum.join([mock["TxnId"], config.api_key, mock["OrderId"], mock["ResultCode"]])
    checksum_binary = :crypto.hash(:md5, seed)
    Map.put(mock, "Checksum", Base.encode16(checksum_binary, case: :lower))
  end
end
