defmodule Point.AccountService do
  import Ecto.Query
  import Decimal
  import Point.DecimalUtil, only: [is: 2, zero: 0]
  alias Point.{Repo, Account, Currency, User}

  # Crud
  def all, do: Repo.all(Account)
  def insert(params), do: Repo.insert(insert_changeset(params))
  def insert!(params), do: Repo.insert(insert_changeset(params))
  def delete(owner_email: owner_email, currency_code: currency_code) do
    case by(email: owner_email, currency_code: currency_code) do
      nil -> {:error, "Account not found"}
      account ->
        cond do
          is(account.amount, greater_that: zero) -> {:error, "Account must be empty to be deleted"}
          true -> Repo.delete(account)
        end
    end
  end

  def amount(account), do: get!(account.id).amount

  def get!(id), do: Repo.get!(Account, id)
  def get(id), do: Repo.get(Account, id)
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
    Account.changeset(account, %{amount: add(account.amount, new(amount))})
  end

  def decrease_changeset(account, amount) do
    Account.changeset(account, %{amount: sub(account.amount, new(amount))})
  end

  defp insert_changeset(params), do: Account.insert_changeset(%Account{}, Map.merge(%{"type" => "default"}, params))
end
