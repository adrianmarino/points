defmodule Point.MovementService do
  alias Point.ExtractService
  alias Point.TransferService
  alias Point.DepositService

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
    end
  end

  @doc """
    Transfer an amount between accounts of any type (backup/default).
  """
  def transfer(from: source, to: target, amount: amount) do
    TransferService.transfer(from: source, to: target, amount: amount)
  end

  @doc """
    Extract amount from bacup account.
  """
  def extract(amount: amount, from: account), do: ExtractService.extract(amount: amount, from: account)

  @doc """
    Deposit amount to backup account.
  """
  def deposit(amount: amount, on: account), do: DepositService.deposit(amount: amount, on: account)
end
