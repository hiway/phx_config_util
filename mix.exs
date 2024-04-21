defmodule PhxConfigUtil.MixProject do
  use Mix.Project

  def project do
    [
      app: :phx_config_util,
      version: "0.1.0",
      source_url: "https://github.com/hiway/phx_config_util/",
      homepage_url: "https://github.com/hiway/phx_config_util/",
      description: description(),
      package: package(),
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:net_address, "~> 0.3.1"},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Utility functions to configure Elixir/ Phoenix apps."
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/hiway/phx_config_util/"}
    ]
  end
end
