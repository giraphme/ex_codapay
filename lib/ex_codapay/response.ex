defmodule ExCodapay.Response do
  defstruct [
    :txn_id,
    :txn_timeout,
    :result_code,
    :result_description,
    :pay_instructions,
    :total_price,
    :payment_code,
    :profile,
    :raw_request_body,
    :request_url,
    :raw_response_body,
    :response_status_code,
    :request
  ]

  def from_httpostion(
        {:ok, %HTTPoison.Response{body: body} = response},
        %ExCodapay.Request{} = request,
        raw_request_body
      ) do
    with {:ok, parsed_body} <- Jason.decode(body) do
      response = %ExCodapay.Response{
        txn_id: parsed_body["txn_id"],
        txn_timeout: parsed_body["txn_timeout"],
        result_code: parsed_body["result_code"],
        result_description: parsed_body["result_desc"],
        pay_instructions: parsed_body["pay_instructions"],
        total_price: parsed_body["total_price"],
        payment_code: parsed_body["profile"]["payment_code"],
        profile: parsed_body["profile"],
        request_url: response.request_url,
        raw_request_body: raw_request_body,
        response_status_code: response.status_code,
        raw_response_body: body,
        request: request
      }

      if success?(response) do
        {:ok, response}
      else
        {:error, response}
      end
    end
  end

  def success?(%__MODULE__{result_code: 0}), do: true
  def success?(%__MODULE__{result_code: _}), do: false
end
