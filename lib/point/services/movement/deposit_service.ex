defmodule Point.DepositService do
  import PointLogger
  import Point.Repo
  import Point.MovementFactory
  import Point.AccountService
  alias Point.Account
  alias Ecto.Multi

  def deposit(amount: amount, to: %Account{} = account) do
    {:ok, %{deposit: movement}} = Multi.new
      |> Multi.update(:increase_amount, increase_changeset(account, amount))
      |> Multi.insert(:deposit, deposit(account, amount))
      |> transaction

    debug(movement)
    movement
  end
end
