defmodule Transfer do
  use Transaction

  defparams do
    acc = %{email: :required, currency: :required}
    %{from: acc, to: acc, amount: :required}
  end

  def perform(params) do
    transfer(
      from: account(email: params.from.email, currency: params.from.currency),
      to: account(email: params.to.email, currency: params.to.currency),
      amount: params.amount
    )
  end
end
