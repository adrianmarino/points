defmodule Example do
  use Transaction

  def run(params) do
    source = account(email: params.from.email, currency: params.from.currency)
    target = account(email: params.to.email, currency: params.to.currency)

    log("Before", source, target)
    transfer(from: source, to: target, amount: 100)
  end

  defp log(message, source, target) do
    print(message)
    print(to_string source)
    print(to_string target)
  end
end

Example.run %{from: %{email: "obiwankenoby@gmail.com", currency: "RBL"},
              to: %{email: "anakinskywalker@gmail.com", currency: "EMP"}}
