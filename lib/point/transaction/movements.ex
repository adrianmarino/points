defmodule Transfer do
  use Transaction
  def perform(params), do: print(transfer(
    from: account(email: params.from.email, currency: params.from.currency),
    to: account(email: params.to.email, currency: params.to.currency),
    amount: params.amount))
end

defmodule Deposit do
  use Transaction
  def perform(params), do: print(deposit(amount: params.amount,
    on: account(email: params.to.email, currency: params.to.currency)))
end

defmodule Extract do
  use Transaction
  def perform(params), do: print(extract(from: account(email: params.from.email, currency: params.from.currency),
    amount: params.amount))
end
