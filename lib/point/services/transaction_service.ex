defmodule Point.TransactionService do
  alias Point.{Repo, Transaction, TransactionCli}

  def execute(transaction, params), do: TransactionCli.execute(transaction, params)

  def insert(name: name, source: source) do
    case TransactionCli.compile(name, source) do
      {:ok, _} -> Repo.insert(Transaction.changeset(%Transaction{}, %{name: name, source: source}))
      error -> error
    end
  end

  def by(name: name), do: Repo.get_by(Transaction, name: name)
end
