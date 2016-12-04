defmodule ServiceSpecHelper do
  import Decimal
  import Point.Repo
  import Point.AccountService

  def ok_result({:ok, value } = _), do: value

  def plus(account, amount), do: round(add(account.amount, amount), 2)
  def minus(account, amount), do: round(sub(account.amount, amount), 2)

  def amount(account), do: fn-> round(refresh(account).amount, 2) end
  def backup_amount(account), do: fn-> round(backup_account_of(account).amount, 2) end
end
