defmodule ExCodapay.RequestTest do
  use ExUnit.Case

  describe "ExCodapay.Request.prepare/2" do
    test "get {:ok, %ExCodapay.Request{}}" do
      config = ExCodapay.Config.new!()

      assert {:ok, %ExCodapay.Request{}} =
               ExCodapay.Request.prepare(
                 config,
                 merchant_name: "Awesome shop",
                 msisdn: "+819084095707",
                 email: "ex_codapay@example.com",
                 items: []
               )
    end
  end

  describe "ExCodapay.Request.send/3" do
    test "get {:ok, %ExCodapay.Payment{}}" do
      request =
        ExCodapay.Config.new!()
        |> ExCodapay.Request.prepare!(
          merchant_name: "Awesome shop",
          msisdn: "+819084095707",
          email: "ex_codapay@example.com",
          items: [%ExCodapay.Item{code: "abcd", name: "item name", price: 100_000}]
        )

      bank_id = ExCodapay.PayChannel.to_i("BCA")

      assert {:ok, %ExCodapay.Response{}} =
               ExCodapay.Request.send(request, :bank_transfer, pay_channel: bank_id)
    end
  end
end
