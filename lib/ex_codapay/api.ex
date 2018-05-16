defmodule ExCodapay.API do
  def call(%ExCodapay.Request{} = request) do
    raw_request_body = ExCodapay.Request.to_json(request)

    HTTPoison.post(
      ExCodapay.Config.base_url(request.config),
      raw_request_body,
      request_headers()
    )
    |> ExCodapay.Response.from_httpostion(request, raw_request_body)
  end

  defp request_headers do
    [{"Content-Type", "application/json"}]
  end
end
