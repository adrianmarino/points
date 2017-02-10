defmodule Mix.Tasks.Cli.Transactions.Exec do
  use Mix.Task.Point.Client
  @shortdoc "Execute a transaction. Params: session_token name params(as json: '{...}')"
  defrun fn([token | [name | [params | _]]]) -> points(base_url, token) |> transactions(exec: name, params: params) end

  defmodule Transfer do
    use Mix.Task.Point.Client
    @shortdoc "Transfer. Params: session_token name params(as json: '{...}')"
    defrun fn([token, params]) -> points(base_url, token) |> transactions(exec: :transfer, params: params) end
  end
  defmodule Deposit do
    use Mix.Task.Point.Client
    @shortdoc "Deposit. Params: session_token name params(as json: '{...}')"
    defrun fn([token, params]) -> points(base_url, token) |> transactions(exec: :deposit, params: params) end
  end
  defmodule Extract do
    use Mix.Task.Point.Client
    @shortdoc "Extract. Params: session_token name params(as json: '{...}')"
    defrun fn([token, params]) -> points(base_url, token) |> transactions(exec: :extract, params: params) end
  end
end
