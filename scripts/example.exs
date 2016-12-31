defmodule Example do
  use Transaction

  def perform(params) do
    source = to(params)
    target = from(params)
    print [
      "Before",
      source, target,
      "After",
      transfer(from: source, to: target, amount: 100)
    ]
  end

  defp to(params), do: account(email: params.to.email, currency: params.to.currency)
  defp from(params), do: account(email: params.from.email, currency: params.from.currency)
end

require Engine

Engine.run(
  Example,
  params: %{
    from: %{email: "obiwankenoby@gmail.com",    currency: "RBL"},
    to:   %{email: "anakinskywalker@gmail.com", currency: "EMP"}
  }
)
