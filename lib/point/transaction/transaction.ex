defmodule Transaction do
  use Behaviour

  defmacro __using__(_) do
    quote do
      import StdLib
      @behaviour Transaction
    end
  end

  defcallback run(params:: %{})
end

defmodule StdLib do
  alias Point.{AccountService, ExtractService, TransferService, DepositService}
  require Logger

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
  def extract(amount: amount, from: account) do
    ExtractService.extract(amount: dec(amount), from: account)
  end
  def deposit(amount: amount, on: account) do
    DepositService.deposit(amount: dec(amount), on: account)
  end

  def print(message), do: Logger.info(message)

  defp dec(value), do: Decimal.new(value)
end
