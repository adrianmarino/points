defmodule Mix.Tasks.Points.Client.Transactions.Exec do
  use Mix.Task.Point.Client
  @shortdoc "Execute a transaction. Params: token name params(as json: '{...}')"
  defrun fn([token | [name | [params | _]]]) ->
    points(base_url, token) |> exec_transaction(name: name, params: params)
  end

  defmodule Transfer do
    use Mix.Task.Point.Client
    @shortdoc "Transfer. Params: token name params(as json: '{...}')"
    defrun fn([token | [params | _]]) ->
      points(base_url, token) |> exec_transaction(name: "transfer", params: params)
    end
  end
  defmodule Deposit do
    use Mix.Task.Point.Client
    @shortdoc "Deposit. Params: token name params(as json: '{...}')"
    defrun fn([token | [params | _]]) ->
      points(base_url, token) |> exec_transaction(name: "deposit", params: params)
    end
  end
  defmodule Extract do
    use Mix.Task.Point.Client
    @shortdoc "Extract. Params: token name params(as json: '{...}')"
    defrun fn([token | [params | _]]) ->
      points(base_url, token) |> exec_transaction(name: "extract", params: params)
    end
  end
end