defmodule Deposit do
  use Transaction
  def perform(params), do: deposit(amount: params.amount,
    on: account(email: params.to.email, currency: params.to.currency))
end
