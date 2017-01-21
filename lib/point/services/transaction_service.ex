defmodule Point.TransactionService do
  alias Point.{Repo, Transaction, TransactionCli}

  def execute(transaction, params), do: TransactionCli.execute(transaction, params)

  def insert(name: name, source: source) do
    case TransactionCli.compile(name, source) do
      {:ok, _} ->
        attrs = %{name: name, source: source}
        changeset = Transaction.insert_changeset(%Transaction{}, attrs)
        Repo.insert(changeset)
      error -> error
    end
  end

  def update(transaction, source: source) do
    case TransactionCli.compile(transaction.name, source) do
      {:ok, _} ->
        changeset = Transaction.update_changeset(transaction, %{source: source})
        Repo.update(changeset)
      error -> error
    end
  end

  def by(name: name), do: Repo.get_by(Transaction, name: name)

  def delete(name: name) do
    case by(name: name) do
      nil -> {:error, "Not found"}
      _ -> {:ok, "Transaction removed"}
    end
  end
end
