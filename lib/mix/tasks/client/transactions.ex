defmodule Mix.Tasks.Points.Client.Transactions do
  use Mix.Task.Point.Client
  @shortdoc "Show transactions. Params: token"
  defrun fn([token | _]) -> points(base_url, token) |> transactions end

  defmodule Show do
    use Mix.Task.Point.Client
    @shortdoc "Show a transaction. Params: token name"
    defrun fn([token | [name | _]]) -> points(base_url, token) |> show_transaction(name: name) end
  end
  defmodule Create do
    use Mix.Task.Point.Client
    @shortdoc "Create a transaction. Params: token name source"
    alias Point.Client.Transaction
    defrun fn([token | transaction]) -> points(base_url, token) |> add_transaction(Transaction.create(transaction)) end
  end
  defmodule Update do
    use Mix.Task.Point.Client
    @shortdoc "Update a transaction. Params: token name source"
    alias Point.Client.Transaction
    defrun fn([token | transaction]) ->
      points(base_url, token) |> update_transaction(Transaction.create(transaction))
    end
  end
  defmodule Delete do
    use Mix.Task.Point.Client
    @shortdoc "Delete a transaction. Params: token name"
    defrun fn([token | [name | _]]) -> points(base_url, token) |> delete_transaction(name: name) end
  end
  defmodule Exec do
    use Mix.Task.Point.Client
    @shortdoc "Execute a transaction. Params: token name paras(as json: '{...}')"
    defrun fn([token | [name | [params | _]]]) ->
      points(base_url, token) |> exec_transaction(name: name, params: params)
    end
  end
end
