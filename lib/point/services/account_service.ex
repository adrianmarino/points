defmodule Point.AccountService do
  import Ecto.Query
  import Decimal
  import Point.DecimalUtil, only: [is: 2, zero: 0]
  alias Point.{Repo, Account}

  def all, do: Repo.all(Account)

  def insert(params) do
    params = Map.merge(%{"type" => "default"}, params)
    changeset = Account.insert_changeset(%Account{}, params)
    Repo.insert(changeset)
  end

  def get!(id), do: Repo.get!(Account, id)
  def delete!(id) do
    case get!(id) do
      nil -> {:error, "Account not found"}
      account ->
        cond do
          is(account.amount, greater_that: zero) -> {:error, "Account must be empty to be deleted"}
          true -> Repo.delete(account)
        end
    end
  end

  def update(id, params) do
    account = get!(id)
    changeset = Account.update_changeset(account, params)
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
