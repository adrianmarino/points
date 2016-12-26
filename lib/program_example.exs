defmodule Example do
  use StdLib

  def run(params \\ %{}) do
    source = account(email: params.from.email, currency: params.from.currency)
    target = account(email: params.to.email, currency: params.to.currency)

    log("Before", params, source, target)

    transfer(from: source, to: target, amount: 100)

    log("After", params, source, target)
  end

  defp log(message, params, source, target) do
    print(message)
    print("Email: #{params.from.email} - Amount: #{params.from.currency} #{to_string amount(source)}")
    print("Email: #{params.to.email} - Amount: #{params.to.currency} #{to_string amount(target)}")
  end
end

Example.run %{from: %{email: "obiwankenoby@gmail.com", currency: "RBL"},
              to: %{email: "anakinskywalker@gmail.com", currency: "EMP"}}
