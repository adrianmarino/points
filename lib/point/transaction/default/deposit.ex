defmodule Deposit do
  use Transaction

  defparams do: %{to: %{email: :required, currency: :required}, amount: :required}

  def perform(params), do: deposit(amount: params.amount,
    on: account(email: params.to.email, currency: params.to.currency))
end
