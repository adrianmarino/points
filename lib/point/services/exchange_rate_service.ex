defmodule Point.ExchangeRateService do
  alias Point.ExchangeRate
  alias Point.Model
  import Ecto.Query
  import Point.Repo
  alias Point.DecimalUtil

  def rate_between(%{currency_id: source}, %{currency_id: target}) when source == target, do: {:ok, Decimal.new(1)}
  def rate_between(source, target) do
    case one(from r in ExchangeRate, where: r.source_id == ^source.currency_id
      and r.target_id == ^target.currency_id)
    do
      rate when rate != nil -> {:ok , Decimal.new(rate.value)}
      _ ->
        case one(from r in ExchangeRate, where: r.source_id == ^target.currency_id
              and r.target_id == ^source.currency_id)
        do
          rate when rate != nil -> {:ok, DecimalUtil.inverse(rate.value) }
          _ ->  {:error, "Missing exchange rate between #{Model.to_string assoc(source, :currency)} and #{Model.to_string assoc(target, :currency)}!"}
        end
    end
  end
end
