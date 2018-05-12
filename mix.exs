defmodule ExCodapay.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_codapay,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:uuid, "~> 1.1"},
      {:httpoison, "~> 1.1"},
      {:jason, "~> 1.0"},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false, github: "ignota/mix-test.watch"}
    ]
  end
end
