defmodule Point.ExtractService do
  alias Point.{Account, Model}
  alias Ecto.Multi
  alias Point.ExchangeRateService
  alias Point.DecimalUtil
  import Logger
  import Point.Repo
  import Ecto.Query
  import Point.AccountService
  import Point.MovementFactory
  import Enum
  import Decimal

  def extract(amount: _, from: %Account{type: "default"} = account) do
    raise "Mustn't extract amount from '#{assoc(account, :owner).email}' default account!. Only allowed with backup accounts."
  end
  def extract(amount: amount, from: %Account{type: "backup"} = account) do
      available_amount = calculate_available_amount(account)
      info("Available Amount: #{assoc(account, :currency).code} #{round(available_amount, 2)}, Extract amount: #{assoc(account, :currency).code} #{amount}")
      assert_that(amount, is_less_or_equal_that: available_amount)

      {:ok, %{extract: movement}} = Multi.new
        |> Multi.update(:decrease_amount, decrease_changeset(account, amount))
        |> Multi.insert(:extract, deposit(account, amount))
        |> transaction

      debug(Model.to_string movement)
      {:ok, movement}
  end

  defp assert_that(amount, is_less_or_equal_that: available_amount) do
    if DecimalUtil.compare(available_amount, amount) < 0,
      do: raise "Available account amount is less that to amount to be extracted! (Available) #{available_amount} < #{amount} (To extract)."
  end

  @doc """
  Option1: Iterate all default accounts of issuer and convert each amount to backup currency.
  Finally sum all amounts and return.
  Option2: Use Balance breakpoints.
  """
  def calculate_available_amount(backup_account) do
    all(from acc in Account, where: acc.type != "backup" and acc.issuer_id == ^backup_account.owner_id)
      |> map(fn(account)->
          {:ok, rate } = ExchangeRateService.rate_between(account, backup_account)
          mult(new(account.amount), rate)
        end)
      |> reduce(new(0), &add/2)
  end
end
