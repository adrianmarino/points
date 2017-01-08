defmodule Point.ExchangeRateService do
  alias Point.{ExchangeRate, DecimalUtil, Repo, Currency}
  import Ecto.Query

  def by(source_code: source_code, target_code: target_code) do
    model = Repo.one(from r in ExchangeRate,
    join: s in Currency,
    join: t in Currency,
    where: r.source_id == s.id and r.target_id == t.id and s.code == ^source_code and t.code == ^target_code)

    case model do
      nil  -> {:error, "Not found exchange rate #{source_code} to #{target_code}"}
      exchange_rate -> {:ok, exchange_rate}
    end
  end

  def rate_between(%{currency_id: source}, %{currency_id: target}) when source == target, do: {:ok, Decimal.new(1)}
  def rate_between(source, target) do
    case Repo.one(from r in ExchangeRate, where: r.source_id == ^source.currency_id
      and r.target_id == ^target.currency_id)
    do
      rate when rate != nil -> {:ok , Decimal.new(rate.value)}
      _ ->
        case Repo.one(from r in ExchangeRate, where: r.source_id == ^target.currency_id
              and r.target_id == ^source.currency_id)
        do
          rate when rate != nil -> {:ok, DecimalUtil.inverse(rate.value) }
          _ -> {:error, missing_exchange_rate_message(source, target)}
        end
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
    case by(source_code: source_code, target_code: target_code) do
      {:ok, exchange_rate} ->
        changeset = ExchangeRate.update_changeset(exchange_rate, %{value: value})
        Repo.update(changeset)
      error -> error
    end
  end
  def delete(source_code: source_code, target_code: target_code) do
    case by(source_code: source_code, target_code: target_code) do
      {:ok, exchange_rate} -> Repo.delete(exchange_rate)
      error -> error
    end
  end

  defp missing_exchange_rate_message(source, target) do
    source_str_rep = to_string Repo.assoc(source, :currency)
    target_str_rep = to_string Repo.assoc(target, :currency)
    "Missing exchange rate between #{source_str_rep} and #{target_str_rep}!"
  end

  defp insert_changeset(source_code, target_code, value) do
    ExchangeRate.insert_changeset(
      %ExchangeRate{},
      %{source_code: source_code, target_code: target_code, value: value}
    )
  end
end
