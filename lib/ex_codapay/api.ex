defmodule ExCodapay.API do
  def call(%ExCodapay.Request{} = request) do
    HTTPoison.post(
      ExCodapay.Config.base_url(request.config),
      ExCodapay.Request.to_json(request),
      request_headers()
    )
    |> ExCodapay.Response.from_httpostion(request)
  end

  defp request_headers do
    [{"Content-Type", "application/json"}]
  end
end
