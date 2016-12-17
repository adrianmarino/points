defmodule Point.AccountService do
  import Ecto.Query
  import Decimal
  alias Point.{Repo, Account}

  def all, do: Repo.all(Account)

  def insert(params) do
    params = Map.merge(%{"type" => "default"}, params)
    changeset = Account.save_changeset(%Account{}, params)
    Repo.insert(changeset)
  end

  def get!(id), do: Repo.get!(Account, id)
  def delete!(id), do: Repo.delete!(get!(id))

  def update(id, params) do
    account = get!(id)
    changeset = Account.save_changeset(account, params)
    Repo.update(changeset)
  end

  def backup_account_of(account) do
    Repo.one(from a in Account, where: a.type == "backup" and a.owner_id == ^account.issuer_id)
  end

  def increase_changeset(account, amount) do
    Repo.changeset(account, %{amount: add(account.amount, new(amount))})
  end

  def decrease_changeset(account, amount) do
    Repo.changeset(account, %{amount: sub(account.amount, new(amount))})
  end
end
