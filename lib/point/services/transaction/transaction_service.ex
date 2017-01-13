defmodule Point.TransactionService do
  alias Point.{Repo, Transaction, TransactionRunner}

  def execute(transaction, params), do: TransactionRunner.execute(transaction, params)

  def insert(name: name, source: source) do
    case Code.string_to_quoted(source) do
      {:error, message} -> {:error, elem(message, 1)}
      {:ok, _} -> Repo.insert(Transaction.changeset(%Transaction{}, %{name: name, source: source}))
    end
  end

  def by(name: name), do: Repo.get_by(Transaction, name: name)
end
