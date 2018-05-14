defmodule ExCodapay.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_codapay,
      version: "0.1.3",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: "Codapay API wrapper for Elixir",
      package: [
        maintainers: ["Tamaki Maeda"],
        licenses: ["MIT"],
        links: %{
          "Codapay" => "https://www.codapay.com"
        }
      ],
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
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false, github: "ignota/mix-test.watch"}
    ]
  end
end
