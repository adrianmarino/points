defmodule Point.TransactionService do
  import Ecto.Query
  alias Point.{Repo, Transaction, User, Transaction.CLI}

  def by(name: name, issuer_id: issuer_id), do: Repo.get_by(Transaction, name: name, issuer_id: issuer_id)
  def by(issuer_id: issuer_id) do
    Repo.all(from t in Transaction, join: u in User, where: t.issuer_id == u.id and u.id == ^issuer_id)
  end
  def execute(transaction, params), do: CLI.execute(transaction, params)

  # Crud
  def all, do: Repo.all(Transaction)
  def insert(attrs) do
    with {:ok, _} <- CLI.compile(attrs.name, attrs.source),
      do: Repo.insert(Transaction.insert_changeset(%Transaction{}, attrs))
  end
  def update(transaction, source: source) do
    with {:ok, _} <- CLI.compile(transaction.name, source),
         changeset <- Transaction.update_changeset(transaction, %{source: source}),
      do: Repo.update(changeset)
  end
  def delete(name: name, issuer_id: issuer_id) do
    case by(name: name, issuer_id: issuer_id) do
      nil -> {:error, "Not found"}
      _ -> {:ok, "Transaction removed"}
    end
  end
end
