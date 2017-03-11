defmodule Point.CurrencyService do
  alias Point.{Repo, Currency, AccountService}

  # Crud
  def all, do: Repo.all(Currency)
  def by(code: code), do: Repo.get_by(Currency, code: code)
  def insert(params), do: Repo.insert(insert_changeset(params))
  def insert!(params), do: Repo.insert!(insert_changeset(params))
  def update(code, params), do: Repo.update(update_changeset(code, params))
  def delete(code) do
    case by(code: code) do
      nil -> {:error, "Not found"}
      currency ->
        case AccountService.by(currency_code: code) do
          [] -> Repo.delete(currency)
          _ -> {:error, "there are account that use this currency"}
        end
    end
  end

  defp insert_changeset(params), do: Currency.insert_changeset(%Currency{}, params)
  defp update_changeset(code, params), do: Currency.update_changeset(by(code: code), params)
end
