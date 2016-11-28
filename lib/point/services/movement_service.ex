defmodule Point.Services.MovementService do
  import Decimal
  import Logger
  import Point.Repo
  alias Point.{MovementFactory, Model}

  def deposit(on: %Point.Account{type: "default"} = _, amount: _) do
    raise "Deposite only is supported in default accounts!"
  end
  def deposit(on: %Point.Account{type: "backup"} = account, amount: amount) do
    balance = add(new(amount), new(account.amount))
    save(account, %{amount: balance})
    logger insert!(MovementFactory.deposit(account, amount))
  end

  defp logger(model)  do
    info(Model.to_string model)
    model
  end
end
