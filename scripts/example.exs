defmodule Example do
  use Transaction

  def perform(params) do
    source = to(params)
    target = from(params)
    movement = transfer(from: source, to: target, amount: 100)
    print ["Before", source, target, "After", movement]
  end

  defp to(params), do: account(email: params.to.email, currency: params.to.currency)
  defp from(params), do: account(email: params.from.email, currency: params.from.currency)
end
