defmodule Point.TransferService do
  @moduledoc """
  Transfer an amount between two accounts with same/distinct currency.
  """
  alias Ecto.Multi
  alias Point.Model
  alias Point.Account

  import Logger
  import Point.Repo
  import Point.MovementFactory, only: [transfer: 3]
  import Point.AccountService, only: [increase_changeset: 2,
                                      decrease_changeset: 2,
                                      backup_account_of: 1]

  def transfer(from:    %Account{type: "default"} = source,
               to:      %Account{type: "default"} = target,
               amount:  amount) do
    movement_name = move_name(source, target)

    {:ok, %{^movement_name => movement}} = Multi.new
      |> append(backup_account_of(source), backup_account_of(target), amount)
      |> append(source, target, amount)
      |> transaction

    info(Model.to_string movement)
    {:ok, movement}
  end

  defp append(query, %{id: source_id}, %{id: target_id}, _) when source_id == target_id, do: query
  defp append(query, _, _, amount) when amount <= 0, do: query
  defp append(query, source, target, amount) do
    query
      |> Multi.update("inc_amount_#{target.id}", increase_changeset(target, amount))
      |> Multi.update("dec_amount_#{source.id}", decrease_changeset(source, amount))
      |> Multi.insert(move_name(source, target), transfer(source, target, amount))
  end

  defp move_name(source, target), do: "move_#{source.id}_to_#{target.id}"
end
