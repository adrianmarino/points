defmodule Example do
  use Transaction

  def run(params) do
    source = account(email: params.from.email, currency: params.from.currency)
    target = account(email: params.to.email, currency: params.to.currency)

    log("<< Before >>", source, target)
    print("<< After >>")

    transfer(from: source, to: target, amount: 100)
  end

  defp log(message, source, target) do
    print(message)
    print_account(source)
    print_account(target)
  end
  defp print_account(account), do: print("Account: #{to_string account}")
end

Example.run %{from: %{email: "obiwankenoby@gmail.com", currency: "RBL"},
              to: %{email: "anakinskywalker@gmail.com", currency: "EMP"}}
