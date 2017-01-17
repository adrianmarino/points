defmodule Extract do
  use Transaction
  def perform(params), do: extract(from: account(email: params.from.email, currency: params.from.currency),
    amount: params.amount)
end
