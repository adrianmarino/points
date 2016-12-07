defmodule Point.TransferService do
  @moduledoc """
  Transfer an amount between two accounts with same/distinct currency.
  """
  alias Ecto.Multi
  alias Point.{Model, Account, ExchangeRateService}

  import Point.Repo
  import Logger
  import Point.MovementFactory
  import Point.AccountService
  import Decimal

  def transfer(from:    %Account{type: "default"} = source,
               to:      %Account{type: "default"} = target,
               amount:  amount) do
    backup_target = backup_account_of(target)
    backup_source = backup_account_of(source)
    backup_amount = mult(amount, rate_between(source, backup_source))

    {:ok, result} = Multi.new
      |> append(backup_source, backup_target, backup_amount)
      |> append(source, target, amount)
      |> transaction

    backup_data = result[move_name(backup_source, backup_target)]
    if backup_data, do: debug("BACKUP  - #{Model.to_string backup_data}")
    movement = result[move_name(source, target)]
    debug("DEFAULT - #{Model.to_string movement}")
    {:ok, movement}
  end

  defp rate_between(source, target) do
    result = ExchangeRateService.rate_between(source, target)
    case result do
      {:error, message} ->
        debug(message)
        Decimal.new(1)
      {:ok, rate} -> rate
    end
  end
  defp append(query, %{id: source_id}, %{id: target_id}, _) when source_id == target_id, do: query
  defp append(query, _, _, amount) when amount <= 0, do: query
  defp append(query, source, target, amount) do
    rate = rate_between(source, target)
    query
      |> Multi.update("dec_amount_#{source.id}", decrease_changeset(source, amount))
      |> Multi.update("inc_amount_#{target.id}", increase_changeset(target, mult(amount, rate)))
      |> Multi.insert(move_name(source, target), transfer(source, target, amount, rate))
  end

  defp move_name(source, target), do: "move_#{source.id}_to_#{target.id}"
end
