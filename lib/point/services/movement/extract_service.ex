defmodule Point.ExtractService do
  alias Point.{Account, ExchangeRateService, DecimalUtil}
  alias Ecto.Multi

  import PointLogger
  import Point.Repo
  import Ecto.Query
  import Point.AccountService
  import Point.MovementFactory
  import Enum

  def extract(amount: _, from: %Account{type: "default"} = account) do
    raise "Mustn't extract amount from '#{assoc(account, :owner).email}' default account!. Only allowed with backup accounts."
  end
  def extract(amount: amount, from: %Account{type: "backup"} = account) do
      available_amount = calculate_available_amount(account)
      info("Available Amount: #{assoc(account, :currency).code} #{Decimal.round(available_amount, 2)}, Extract amount: #{assoc(account, :currency).code} #{amount}")
      assert_that(amount, is_less_or_equal_that: available_amount)

      {:ok, %{extract: movement}} = Multi.new
        |> Multi.update(:decrease_amount, decrease_changeset(account, amount))
        |> Multi.insert(:extract, deposit(account, amount))
        |> transaction

      debug(movement)
      {:ok, movement}
  end

  defp assert_that(amount, is_less_or_equal_that: available_amount) do
    if DecimalUtil.compare(available_amount, amount) < 0,
      do: raise "Available account amount is less that to amount to be extracted! (Available) #{available_amount} < #{amount} (To extract)."
  end

  defp calculate_available_amount(backup_account) do
    all(from acc in Account, where: acc.type != "backup" and acc.issuer_id == ^backup_account.owner_id)
      |> map(fn(account)->
          {:ok, rate } = ExchangeRateService.rate_between(account, backup_account)
          Decimal.mult(Decimal.new(account.amount), rate)
        end)
      |> reduce(Decimal.new(0), &Decimal.add/2)
  end
end
