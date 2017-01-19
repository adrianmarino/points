defmodule ServiceSpecHelper do
  import Decimal
  import Point.Repo
  alias Point.{AccountService, ExchangeRateService}

  def plus(account, amount), do: round(add(account.amount, amount), 2)
  def minus(account, amount), do: round(sub(account.amount, amount), 2)

  def amount(account), do: fn-> round(AccountService.get!(account.id).amount, 2) end

  def currency_code(account), do: assoc(account, :currency).code

  def owner_email(account), do: assoc(account, :owner).email

  def source_id(movement), do: assoc(movement, :source).id

  def target_id(movement), do: assoc(movement, :target).id

  def backup_amount(account), do: fn-> round(AccountService.backup_account_of(account).amount, 2) end

  def rate(source_account, target_account, value) do
    ExchangeRateService.insert!(
      source_code: currency_code(source_account),
      target_code: currency_code(target_account),
      value: Decimal.new(value)
    )
  end
end
