defmodule ExCodapay.PayChannelTest do
  use ExUnit.Case

  describe "ExCodapay.PayChannel.to_i/1" do
    test "get a number" do
      assert 7 == ExCodapay.PayChannel.to_i("Permata")
    end
  end

  describe "ExCodapay.PayChannel.to_s/1" do
    test "get a string" do
      assert "Permata" == ExCodapay.PayChannel.to_s(7)
    end
  end

  describe "ExCodapay.PayChannel.filter_pay_channels/2" do
    test "get a list of pay_channel ids" do
      assert channels = ExCodapay.PayChannel.filter_pay_channels(:indonesia, :otc)
      assert is_list(channels)
      assert channels = ExCodapay.PayChannel.filter_pay_channels(:indonesia, :bank)
      assert is_list(channels)
    end
  end
end
