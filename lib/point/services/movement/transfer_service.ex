defmodule Point.TransferService do
  @moduledoc """
  Transfer an amount between two accounts with same/distinct currency.
  """
  alias Ecto.Multi
  alias Point.{Account, ExchangeRateService, PartnerService}

  import Point.Repo
  import Point.MovementFactory
  import Point.AccountService
  import PointLogger

  def is_transfer_allowed?(between: source, and: target) do
    PartnerService.are_they_partners?(source.entity_id, target.entity_id)
  end

  def transfer(from:    %Account{} = source,
               to:      %Account{} = target,
               amount:  amount) do
    assert_transfer_allowed(between: source, and: target)

    {:ok, result} = Multi.new
      |> append(source, target, amount)
      |> transaction

    result[move_name(source, target)]
  end

  defp assert_transfer_allowed(between: source, and: target) do
    unless is_transfer_allowed?(between: source, and: target),
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
