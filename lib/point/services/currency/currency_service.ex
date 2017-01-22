defmodule Point.CurrencyService do
  alias Point.{Repo, Currency, AccountService}

  def by(code: code), do: Repo.get_by(Currency, code: code)

  # Crud
  def all, do: Repo.all(Currency)
  def get(id), do: Repo.get(Currency, id)
  def get!(id), do: Repo.get!(Currency, id)
  def insert(params), do: Repo.insert(changeset(params))
  def insert!(params), do: Repo.insert!(changeset(params))
  def update(code, params), do: Repo.update(Currency.changeset(by(code: code), params))
  def delete(code) do
    case by(code: code) do
      nil -> {:error, "Not found"}
      currency ->
        case AccountService.by(currency_code: code) do
          [] ->
            Repo.delete!(currency)
            {:ok, "currency removed"}
          _ -> {:error, "there are account that use this currency"}
        end
    end
  end

  defp changeset(params), do: Currency.changeset(%Currency{}, params)
end
