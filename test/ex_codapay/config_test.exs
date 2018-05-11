defmodule ExCodapay.ConfigTest do
  use ExUnit.Case

  describe "ExCodapay.Config.new/1" do
    test "get {:ok, %ExCodapay.Config{}}" do
      assert {:error, "Can't find api_key"} = ExCodapay.Config.new()
      System.put_env("CODAPAY_API_KEY", "API_KEY_FROM_SYSTEM_ENV")
      assert {:error, "Can't find pay_types"} = ExCodapay.Config.new()
      Application.put_env(:ex_codapay, :pay_types, [:invalid])
      assert {:error, "Has unsupported pay_type"} = ExCodapay.Config.new()
      Application.put_env(:ex_codapay, :pay_types, [:otc, :bank])

      assert {:ok,
              %ExCodapay.Config{
                api_key: "API_KEY_FROM_SYSTEM_ENV",
                country: :indonesia,
                language: :in,
                pay_types: [:otc, :bank],
                pay_channels: nil,
                sandbox_mode: true
              }} == ExCodapay.Config.new()
    end
  end
end
