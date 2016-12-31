defmodule StandardLib do
  alias Point.{AccountService, ExtractService, TransferService, DepositService}
  import PointLogger

  def refresh(model), do: Point.Repo.refresh(model)
  def amount(account), do: AccountService.amount(account)
  def account(email: email, currency: currency) do
    case AccountService.by(email: email, currency_code: currency) do
      nil -> raise "Not found account for #{email} with #{currency} currency!"
      account -> account
    end
  end
  def transfer(from: source, to: target, amount: amount) do
    TransferService.transfer(from: source, to: target, amount: dec(amount))
  end
  def extract(amount: amount, from: account), do: ExtractService.extract(amount: dec(amount), from: account)
  def deposit(amount: amount, on: account), do: DepositService.deposit(amount: dec(amount), on: account)

  def print(message) do
    case message do
      message when is_list(message) -> Enum.each(message, &(info/1))
      message -> info(message)
    end
  end

  defp dec(value), do: Decimal.new(value)
end
