defmodule Point.DepositService do
  alias Point.Model
  alias Point.Account
  alias Ecto.Multi

  import Logger
  import Point.Repo
  import Point.MovementFactory
  import Point.AccountService

  def deposit(amount: _, on: %Account{type: "default"} = _),
    do: raise "Deposite only is supported in default accounts!"
  def deposit(amount: amount, on: %Account{type: "backup"} = account) do
    {:ok, %{movement: movement}} = Multi.new
      |> Multi.update(:increase_amount, increase_changeset(account, amount))
      |> Multi.insert(:movement, deposit(account, amount))
      |> transaction

    info(Model.to_string movement)
    {:ok, movement}
  end
end
