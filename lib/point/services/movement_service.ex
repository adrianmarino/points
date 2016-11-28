defmodule Point.Services.MovementService do
  import Logger
  import Point.Repo
  import Point.MovementFactory, only: [deposit: 2, transfer: 3]
  import Point.AccountService, only: [increase: 2, decrease: 2]

  alias Point.Model

  def transfer( from:   %Point.Account{type: "backup"} = _,
                to:     %Point.Account{type: "backup"} = _,
                amount: _), do: raise "Unimplemented!"
  def transfer( from:    %Point.Account{type: "default"} = source,
                to:      %Point.Account{type: "default"} = target,
                amount:  amount) do
    logger insert!(transfer(decrease(source, amount), increase(target, amount), amount))
  end

  def deposit(amount: _, on: %Point.Account{type: "default"} = _) do
    raise "Deposite only is supported in default accounts!"
  end
  def deposit(amount: amount, on: %Point.Account{type: "backup"} = account) do
    logger insert!(deposit(increase(account, amount), amount))
  end

  defp logger(model)  do
    info(Model.to_string model)
    model
  end
end
