defmodule Point.Services.MovementService do
  alias Ecto.Multi
  alias Point.Model
  alias Point.Account

  import Logger
  import Point.Repo
  import Point.MovementFactory, only: [deposit: 2, transfer: 3]
  import Point.AccountService, only: [increase_changeset: 2, decrease_changeset: 2]

  def transfer( from:   %Account{type: "backup"} = _,
                to:     %Account{type: "backup"} = _,
                amount: _), do: raise "Unimplemented!"
  def transfer( from:    %Account{type: "default"} = source,
                to:      %Account{type: "default"} = target,
                amount:  amount) do
    get_movement Multi.new
      |> Multi.update(:increase_amount, increase_changeset(target, amount))
      |> Multi.update(:decrease_amount, decrease_changeset(source, amount))
      |> Multi.insert(:movement, transfer(source, target, amount))
      |> transaction
  end

  def deposit(amount: _, on: %Account{type: "default"} = _),
    do: raise "Deposite only is supported in default accounts!"
  def deposit(amount: amount, on: %Account{type: "backup"} = account) do
    get_movement Multi.new
      |> Multi.update(:increase_amount, increase_changeset(account, amount))
      |> Multi.insert(:movement, deposit(account, amount))
      |> transaction
  end

  defp get_movement({:ok, %{movement: movement}} = _) do
    info(Model.to_string movement)
    {:ok, movement}
  end
  defp get_movement(result), do: result
end
