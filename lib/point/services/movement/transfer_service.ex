defmodule Point.TransferService do
  @moduledoc """
  Transfer an amount between two accounts with same/distinct currency.
  """
  alias Ecto.Multi
  alias Point.{Account, ExchangeRateService, AccountService}

  import Point.Repo
  import Point.MovementFactory
  import Point.AccountService
  import PointLogger

  def transfer(from:    %Account{type: "default"} = source,
               to:      %Account{type: "default"} = target,
               amount:  amount) do
    assert_transfer_allowed(between: source, and: target)

    backup_target = backup_account_of(target)
    backup_source = backup_account_of(source)
    backup_amount = Decimal.mult(amount, rate_between(source, backup_source))

    {:ok, result} = Multi.new
      |> append(backup_source, backup_target, backup_amount)
      |> append(source, target, amount)
      |> transaction

    backup_data = result[move_name(backup_source, backup_target)]
    if backup_data, do: debug(backup_data)
    result[move_name(source, target)]
  end

  defp assert_transfer_allowed(between: source, and: target) do
    unless AccountService.is_transfer_allowed?(between: source, and: target),
      do: raise "Transfer Denied: Accounts must be under partner entities or under same entity."
  end
  defp rate_between(source, target) do
    case ExchangeRateService.rate_between(source, target) do
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
    debug("Rate: #{rate}")
    query
      |> Multi.update("dec_amount_#{source.id}", decrease_changeset(source, amount))
      |> Multi.update("inc_amount_#{target.id}", increase_changeset(target, Decimal.mult(amount, rate)))
      |> Multi.insert(move_name(source, target), transfer(source, target, amount, rate))
  end

  defp move_name(source, target), do: "move_#{source.id}_to_#{target.id}"
end
