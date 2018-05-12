defmodule ExCodapay.RequestTest do
  use ExUnit.Case

  describe "ExCodapay.Request.prepare/2" do
    test "get {:ok, %ExCodapay.Request{}}" do
      System.put_env("CODAPAY_API_KEY", "API_KEY_FROM_SYSTEM_ENV")
      config = ExCodapay.Config.new!()

      assert {:ok, %ExCodapay.Request{}} =
               ExCodapay.Request.prepare(
                 config,
                 merchant_name: "Awesome shop",
                 msisdn: "+81 90 8409 5707",
                 email: "ex_codapay@example.com",
                 items: []
               )
    end
  end

  describe "ExCodapay.Request.send/3" do
    test "get {:ok, %ExCodapay.Payment{}}" do
      System.put_env("CODAPAY_API_KEY", "API_KEY_FROM_SYSTEM_ENV")

      request =
        ExCodapay.Config.new!()
        |> ExCodapay.Request.prepare!(
          merchant_name: "Awesome shop",
          msisdn: "+81 90 8409 5707",
          email: "ex_codapay@example.com",
          items: [%ExCodapay.Item{code: "abcd", name: "item name", price: 100_000}]
        )

      bank_id = ExCodapay.PayChannel.to_i("BCA")

      assert {:ok, %ExCodapay.Response{}} =
               ExCodapay.Request.send(request, :bank_transfer, pay_channel: bank_id)
    end
  end
end
