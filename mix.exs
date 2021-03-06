defmodule Point.Mixfile do
  use Mix.Project

  def project do
    [app: :point,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps(),
     preferred_cli_env: [espec: :test]]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Point, []},
     applications: [:phoenix, :phoenix_pubsub, :cowboy, :logger, :gettext, :phoenix_ecto, :mariaex,
                    :ecto_ttl, :timex, :httpotion]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "spec/factories"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.2.1"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.0"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:espec_phoenix, "~> 0.6.4", only: :test},
      {:mariaex, ">= 0.0.0"},
      {:ex_machina, "~> 1.0", only: [:test]},
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:cors_plug, "~> 1.1"},
      {:comeonin, "~> 2.0"},
      {:secure_random, "~> 0.2"},
      {:ecto_ttl, git: "https://github.com/xerions/ecto_ttl.git"},
      {:ecto_migrate, "0.6.3", override: true},
      {:ecto, ">= 2.0.6", override: true},
      {:timex, "~> 3.0"},
      {:timex_ecto, "~> 3.0"},
      {:exjsx, "~> 3.2.1", git: "https://github.com/talentdeficit/exjsx"},
      {:httpotion, "~> 3.0.2"},
      {:ecto_enum, "~> 1.0"}
   ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.clean": ["ecto.drop", "ecto.create", "ecto.migrate"],
      "cli.sessions.delete_all": ["run scripts/delete_sessions.exs"]
    ]
  end
end
