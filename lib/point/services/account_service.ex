defmodule Point.AccountService do
  import Ecto.Query
  import Decimal
  import Point.DecimalUtil, only: [is: 2, zero: 0]
  alias Point.{Repo, Account, Currency, User}

  # Crud
  def all, do: Repo.all(Account)
  def get!(id), do: Repo.get!(Account, id)
  def insert(params) do
    params = Map.merge(%{"type" => "default"}, params)
    changeset = Account.insert_changeset(%Account{}, params)
    Repo.insert(changeset)
  end
  def update(id, params) do
    account = get!(id)
    changeset = Account.update_changeset(account, params)
    Repo.update(changeset)
  end
  def delete(id) do
    case get!(id) do
      nil -> {:error, "Account not found"}
      account ->
        cond do
          is(account.amount, greater_that: zero) -> {:error, "Account must be empty to be deleted"}
          true -> Repo.delete(account)
        end
    end
  end

  def amount(account), do: Repo.refresh(account).amount

  def by(email: email, currency_code: currency_code) do
    Repo.one(from a in Account, join: c in Currency, join: u in User,
             where: a.currency_id == c.id and a.owner_id == u.id and c.code == ^currency_code and u.email == ^email)
  end

  def by(currency_code: currency_code) do
    Repo.all(from a in Account, join: c in Currency, where: a.currency_id == c.id and c.code == ^currency_code)
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
