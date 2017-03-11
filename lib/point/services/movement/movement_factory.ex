defmodule Point.MovementFactory do
  @moduledoc """
  Allow build movement structs used for test purpose.
  """
  alias Point.Movement

  def deposit(account, amount) do
    %Movement{type: "deposit", target: account, amount: amount}
  end
  def extract(account, amount) do
    %Movement{type: "extract", source: account, amount: amount}
  end
  def transfer(source, target, amount, rate) do
    %Movement{
      type: "transfer",
      source: source,
      target: target,
      amount: Decimal.new(amount),
      rate: Decimal.new(rate)
    }
  end
end
