defmodule Point.AccountService do
  import Decimal
  import Point.Repo

  def increase_changeset(account, amount) do
    changeset(account, %{amount: add(account.amount, new(amount))})
  end
  def decrease_changeset(account, amount) do
    changeset(account, %{amount: sub(account.amount, new(amount))})
  end
end
