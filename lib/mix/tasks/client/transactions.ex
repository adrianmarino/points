defmodule Mix.Tasks.Points.Client.Transactions do
  use Mix.Task.Point.Client
  @shortdoc "Show transactions. Params: token"
  defrun fn([token | _]) -> points(base_url, token) |> transactions end

  defmodule Show do
    use Mix.Task.Point.Client
    @shortdoc "Show a transaction. Params: token name"
    defrun fn([token | [name | _]]) -> points(base_url, token) |> transactions(:show, name: name) end
  end
  defmodule Create do
    use Mix.Task.Point.Client
    @shortdoc "Create a transaction. Params: token name source"
    defrun fn([token | transaction]) ->
      points(base_url, token) |> transactions(:create, Transaction.create transaction)
    end
  end
  defmodule Update do
    use Mix.Task.Point.Client
    @shortdoc "Update a transaction. Params: token name source"
    defrun fn([token | transaction]) ->
      points(base_url, token) |> transactions(:update, Transaction.create transaction)
    end
  end
  defmodule Delete do
    use Mix.Task.Point.Client
    @shortdoc "Delete a transaction. Params: token name"
    defrun fn([token | [name | _]]) -> points(base_url, token) |> transactions(:delete, name: name) end
  end
end
