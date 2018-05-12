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
end
