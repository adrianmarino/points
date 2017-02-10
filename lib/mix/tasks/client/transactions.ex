defmodule Mix.Tasks.Cli.Transactions do
  use Mix.Task.Point.Client
  @shortdoc "Show transactions. Param: session_token"
  defrun fn(token) -> points(base_url, token) |> transactions end

  defmodule Show do
    use Mix.Task.Point.Client
    @shortdoc "Show a transaction. Params: session_token name"
    defrun fn([token, name]) -> points(base_url, token) |> transactions(show: name) end
  end
  defmodule Create do
    use Mix.Task.Point.Client
    @shortdoc "Create a transaction. Params: session_token name source"
    defrun fn([token | params]) -> points(base_url, token) |> transactions(create: Transaction.new(params)) end
  end
  defmodule Update do
    use Mix.Task.Point.Client
    @shortdoc "Update a transaction. Params: session_token name source"
    defrun fn([token | params]) -> points(base_url, token) |> transactions(update: Transaction.new(params)) end
  end
  defmodule Delete do
    use Mix.Task.Point.Client
    @shortdoc "Delete a transaction. Params: session_token name"
    defrun fn([token, name]) -> points(base_url, token) |> transactions(delete: name) end
  end
end
