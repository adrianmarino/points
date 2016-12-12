defmodule Point.CurrencyService do
  alias Point.{Repo, Currency}

  def by(code: code), do: Repo.get_by(Currency, code: code)
end
