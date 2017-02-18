defmodule Mix.Tasks.Cli.Roles do
  use Mix.Task.Point.Client
  @shortdoc "Show roles. Param: token"
  defrun fn(token)-> points(base_url, token) |> roles end
end
