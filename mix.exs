defmodule Muggle.MixProject do
  use Mix.Project

  def project do
    [
      app: :muggle,
      version: "0.1.0",
      elixir: "~> 1.12",
      test_coverage: [tool: ExCoveralls],
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
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end
end
