defmodule Point.ExchangeRateService do
  alias Point.{ExchangeRate, DecimalUtil, Repo, Currency}
  import Ecto.Query
  import ExchangeRate

  def by(source_code: source_code, target_code: target_code) do
    Repo.one(
      from r in ExchangeRate,
      join: s in Currency, join: t in Currency,
      where: r.source_id == s.id and r.target_id == t.id and s.code == ^source_code and t.code == ^target_code)
  end

  def by(source: source, target: target) do
    Repo.one(from r in ExchangeRate, where: r.source_id == ^source.currency_id and r.target_id == ^target.currency_id)
  end

  def rate_between(%{currency_id: source}, %{currency_id: target}) when source == target, do: {:ok, Decimal.new(1)}
  def rate_between(source, target) do
    case by(source: source, target: target) do
      nil ->
        case by(source: target, target: source) do
          nil -> {:error, missing_exchange_rate_message(source, target)}
          rate -> {:ok, DecimalUtil.inverse(rate.value) }
        end
      rate -> {:ok , Decimal.new(rate.value)}
    end
  end

  # Crud
  def all, do: Repo.all(ExchangeRate)
  def get(id), do: Repo.get(ExchangeRate, id)
  def get!(id), do: Repo.get!(ExchangeRate, id)
  def insert(source_code: source_code, target_code: target_code, value: value) do
    Repo.insert(insert_changeset(source_code, target_code, value))
  end
  def insert!(source_code: source_code, target_code: target_code, value: value) do
    Repo.insert!(insert_changeset(source_code, target_code, value))
  end
  def update(source_code: source_code, target_code: target_code, value: value) do
    search(source_code: source_code, target_code: target_code,
      found: fn(exchange_rate) -> Repo.update(update_changeset(exchange_rate, %{value: value})) end)
  end
  def delete(source_code: source_code, target_code: target_code) do
    search(source_code: source_code, target_code: target_code, found: fn(exchange_rate) -> Repo.delete(exchange_rate) end)
  end

  defp missing_exchange_rate_message(source, target) do
    source_str_rep = to_string Repo.assoc(source, :currency)
    target_str_rep = to_string Repo.assoc(target, :currency)
    "Missing exchange rate between #{source_str_rep} and #{target_str_rep}!"
  end

  defp insert_changeset(source_code, target_code, value) do
    insert_changeset(%ExchangeRate{}, %{source_code: source_code, target_code: target_code, value: value})
  end

  defp search(source_code: source_code, target_code: target_code, found: found) do
    case by(source_code: source_code, target_code: target_code) do
      nil -> {:error, :not_found }
      model -> found.(model)
    end
  end
end
