defmodule ExCodapay.ConfigTest do
  use ExUnit.Case

  describe "ExCodapay.Config.new/1" do
    test "get {:ok, %ExCodapay.Config{}}" do
      System.delete_env("CODAPAY_API_KEY")
      assert {:error, "Can't find api_key"} = ExCodapay.Config.new()
      System.put_env("CODAPAY_API_KEY", "API_KEY_FROM_SYSTEM_ENV")

      assert {:ok,
              %ExCodapay.Config{
                api_key: "API_KEY_FROM_SYSTEM_ENV",
                country: :indonesia,
                language: :in,
                sandbox_mode: true
              }} == ExCodapay.Config.new()
    end
  end

  describe "ExCodapay.Config.base_url/1" do
    test "get url for production if sandbox_mode is enable" do
      expected_url = "https://airtime.codapayments.com/airtime/offline/charge/v2"
      assert ExCodapay.Config.base_url(%ExCodapay.Config{sandbox_mode: false}) == expected_url
    end

    test "get url for sandbox if sandbox_mode is disable" do
      expected_url = "https://sandbox.codapayments.com/airtime/offline/charge/v2"
      assert ExCodapay.Config.base_url(%ExCodapay.Config{sandbox_mode: true}) == expected_url
    end
  end
end
