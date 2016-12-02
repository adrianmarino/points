defmodule Point.MovementFactory do
  @moduledoc """
  Allow build movement structs used for test purpose.
  """
  alias Point.Movement

  def deposit(account, amount),
    do: %Movement{type: "deposit", target: account, amount: amount}
  def extract(account, amount),
    do: %Movement{type: "extract", source: account, amount: amount}
  def transfer(source, target, amount) do
    %Movement{type: "transfer", source: source, target: target, amount: amount}
  end
end
