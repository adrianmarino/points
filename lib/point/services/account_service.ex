defmodule Point.AccountService do
  import Decimal
  import Point.Repo
  import Ecto.Query
  alias Point.Account

  def backup_account_of(account) do
    one(from a in Account, where: a.type == "backup" and a.owner_id == ^account.issuer_id)
  end
  def increase_changeset(account, amount) do
    changeset(account, %{amount: add(account.amount, new(amount))})
  end
  def decrease_changeset(account, amount) do
    changeset(account, %{amount: sub(account.amount, new(amount))})
  end
end
