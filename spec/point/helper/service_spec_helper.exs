defmodule ServiceSpecHelper do
  import Decimal
  alias Point.AccountService

  def ok_result({:ok, value } = _), do: value

  def plus(account, amount), do: round(add(account.amount, amount), 2)
  def minus(account, amount), do: round(sub(account.amount, amount), 2)

  def amount(account), do: fn-> round(AccountService.get!(account.id).amount, 2) end
  def backup_amount(account), do: fn-> round(AccountService.backup_account_of(account).amount, 2) end
end
