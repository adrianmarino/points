defmodule Point.TransactionService do
  import Macro, only: [camelize: 1]
  alias Point.{Repo, MapUtil, Transaction}
  require Logger

  def execute(name, params) do
    try do
      {result, _} = Code.eval_string(
        """
        require Engine
        Engine.run(#{camelize name}, params)
        """,
        [params: MapUtil.keys_to_atom(params)],
        __ENV__
      )
      result
    rescue
      e -> {:error, e}
    end
  end

  def insert(name: name, source: source) do
    case Code.string_to_quoted(source) do
      {:error, message} -> {:error, elem(message, 1)}
      {:ok, _} -> Repo.insert(Transaction.changeset(%Transaction{}, %{name: name, source: source}))
    end
  end

  def by(name: name), do: Repo.get_by(Transaction, name: name)
end
