defmodule ServiceSpecHelper do
  import Decimal
  import Point.Repo
  import Point.AccountService

  def ok_result({:ok, value } = _), do: value

  def plus(account, amount), do: add(account.amount, amount)
  def minus(account, amount), do: sub(account.amount, amount)

  def amount(account), do: fn-> refresh(account).amount end
  def backup_amount(account), do: fn-> backup_account_of(account).amount end
end
