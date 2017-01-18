use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :point, Point.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [],
  session_ttl: 9000000,
  simultaneous_sessions_by_user_and_remote_ip: 3,
  tmp_compile_path: "./tmp/compile",
  tmp_exec_path: "./tmp/exec"

config :ecto_ttl,
    ignore_newest_seconds: 0,
    cleanup_interval: 30,
    batch_size: 1000

# Do not include metadata nor timestamps in development logs
config :logger,
  :console,
  format: "[$level] $message\n",
  level: :info

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :point, Point.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "1234",
  database: "point_dev",
  hostname: "localhost",
  pool_size: 10
