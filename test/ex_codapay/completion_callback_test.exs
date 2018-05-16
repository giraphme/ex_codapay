defmodule ExCodapay.CompletionCallbackTest do
  use ExUnit.Case

  describe "ExCodapay.CompletionCallback.validate/3" do
    test "get {:ok, %ExCodapay.Request{}}" do
      bank_id = ExCodapay.PayChannel.to_i("BCA")
      config = ExCodapay.Config.new!()

      request =
        ExCodapay.Request.prepare!(
          config,
          merchant_name: "Awesome shop",
          msisdn: "+819084095707",
          email: "ex_codapay@example.com",
          items: [%ExCodapay.Item{code: "abcd", name: "item name", price: 100_000}]
        )

      response = ExCodapay.Request.send!(request, :bank_transfer, pay_channel: bank_id)

      mock_params =
        ExCodapay.Debugger.mock_completion_notification(
          config,
          txn_id: response.txn_id,
          order_id: request.order_id
        )

      ExCodapay.CompletionCallback.validate(mock_params, config, request.order_id)
    end
  end
end
