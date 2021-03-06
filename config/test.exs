use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :point, Point.Endpoint,
  http: [port: 4001],
  server: false,
  session_ttl: 1_800,
  simultaneous_sessions_by_user_and_remote_ip: 1,
  tmp_path: "./tmp",
  http_potion_log_request_as_info_level: :no

# Print only warnings and errors during test
config :logger, level: :error

config :ecto_ttl,
    ignore_newest_seconds: 0,
    cleanup_interval: 0,
    batch_size: 1000

# Configure your database
config :point, Point.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "1234",
  database: "point_test",
  hostname: System.get_env("DB_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  ownership_timeout: 60_000

config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1
