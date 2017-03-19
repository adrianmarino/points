defmodule Extract do
  use Transaction
  defparams do: %{from: %{email: :required, currency: :required}, amount: :required}

  def perform(params),
    do: extract(amount: params.amount, from: account(email: params.from.email, currency: params.from.currency))
end
