defmodule Point.DepositService do
  alias Point.Account
  alias Ecto.Multi

  import PointLogger
  import Point.Repo
  import Point.MovementFactory
  import Point.AccountService

  def deposit(amount: _, on: %Account{type: "default"} = _),
    do: raise "Deposite only is supported in default accounts!"
  def deposit(amount: amount, on: %Account{type: "backup"} = account) do
    {:ok, %{deposit: movement}} = Multi.new
      |> Multi.update(:increase_amount, increase_changeset(account, amount))
      |> Multi.insert(:deposit, deposit(account, amount))
      |> transaction

    debug(movement)
    {:ok, movement}
  end
end
