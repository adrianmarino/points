defmodule Point.TransactionService do
  import Ecto.Query
  alias Point.{Repo, Transaction, User, TransactionCli}

  def by(name: name, issuer_id: issuer_id), do: Repo.get_by(Transaction, name: name, issuer_id: issuer_id)
  def by(issuer_id: issuer_id) do
    Repo.all(from t in Transaction, join: u in User, where: t.issuer_id == u.id and u.id == ^issuer_id)
  end
  def execute(transaction, params), do: TransactionCli.execute(transaction, params)

  # Crud
  def all, do: Repo.all(Transaction)
  def insert(attrs) do
    case TransactionCli.compile(attrs.name, attrs.source) do
      {:ok, _} -> Repo.insert(Transaction.insert_changeset(%Transaction{}, attrs))
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
  def delete(name: name, issuer_id: issuer_id) do
    case by(name: name, issuer_id: issuer_id) do
      nil -> {:error, "Not found"}
      _ -> {:ok, "Transaction removed"}
    end
  end
end
