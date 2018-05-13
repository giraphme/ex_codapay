# ExCodapay

If you want to more information, you can be found at [https://hexdocs.pm/ex_codapay](https://hexdocs.pm/ex_codapay).

## Installation

```elixir
def deps do
  [
    {:ex_codapay, "~> 0.1.0"}
  ]
end
```

## Configuration

```elixir
config :ex_codapay,
  api_key: {:system, "CODAPAY_API_KEY"},
  country: :indonesia, # :indonesia, :malaysia, :singapore, :thailand, :philippines, :vietnam
  language: :in, # :en, :in, :zh, :th, :tl, :vi
  sandbox_mode: true # false
```

## Basic usage

### Direct Billing

Not supported yet.

### Bank, OTC

```elixir
config = ExCodapay.Config.new!()
item = %ExCodapay.Item{code: "abc", name: "excellent book", price: 100_000}
bank_id = ExCodapay.PayChannel.to_id("BCA")

response =
  config
  |> ExCodapay.Request.prepare!(items: [item])
  |> ExCodapay.Request.send!(:bank_transfer, pay_channel: bank_id)

# store txn_id and order_id to your system

#--------

# After receive the completion callback
completed_callback = %ExCodapay.CompletedCallback{txn_id: "...", ...}
order_id = find_from_your_system(completed_callback.txn_id)
ExCodapay.CompletionCallback.check(completed_callback, config, order_id)
```

### For testing

```elixir
ExCodapay.Debugger.mock_completion_notification(config, txn_id: txn_id, order_id: order_id, ...)
#=> %{"TxnId" => "...", ..., "Checksum" => "..."}
```
