defmodule Point.AccountService do
  import Decimal
  import Point.Repo

  def increase(account, amount) do
    save(account, %{amount: add(account.amount, new(amount))})
    refresh account
  end
  def decrease(account, amount) do
    save(account, %{amount: sub(account.amount, new(amount))})
    refresh account
  end
end
