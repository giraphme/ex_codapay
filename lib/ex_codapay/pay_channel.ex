defmodule ExCodapay.PayChannel do
  @supported_all %{
    1 => "BCA",
    2 => "BRI",
    3 => "BII",
    4 => "BNI",
    5 => "CIMB",
    6 => "Mandiri",
    7 => "Permata",
    8 => "Other Banks",
    9 => "Mobile Banking BCA",
    12 => "Mobile Banking BRI",
    13 => "Mobile Banking BII",
    14 => "Mobile Banking BNI",
    15 => "Mobile Banking CIMB",
    16 => "Mobile Banking Mandiri",
    17 => "Mobile Banking Permata",
    18 => "Mobile Banking Other Banks",
    55 => "Alfamart",
    77 => "Indomaret"
  }
  @indonesia_numbers [1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 14, 15, 16, 17, 18, 55, 56, 77]
  @indonesia_bank_numbers [1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 14, 15, 16, 17, 18]
  @indonesia_otc_numbers [55, 56, 77]

  def to_i(str) do
    @supported_all
    |> Enum.find(fn {_, label} -> label == str end)
    |> elem(0)
  end

  def to_s(num) do
    @supported_all[num]
  end

  def filter_pay_channels(country, pay_type \\ nil) do
    Map.take(
      Map.new(@supported_all),
      filter_pay_channel_ids(country, pay_type)
    )
  end

  defp filter_pay_channel_ids(:indonesia, :bank), do: @indonesia_bank_numbers
  defp filter_pay_channel_ids(:indonesia, :otc), do: @indonesia_otc_numbers
  defp filter_pay_channel_ids(:indonesia, nil), do: @indonesia_numbers
  defp filter_pay_channel_ids(_, _), do: []
end
