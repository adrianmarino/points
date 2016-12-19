defmodule Point.CurrencyView do
  use Point.Web, :view
  alias Point.{CurrencyView, Repo}

  def render("index.json", %{currencies: currencies}), do: render_many(currencies, CurrencyView, "currency.json")
  def render("show.json", %{currency: currency}), do: render_one(currency, CurrencyView, "currency.json")

  def render("currency.json", %{currency: currency}) do
    issuer_email = Repo.assoc(currency, :issuer).email
    %{code: currency.code, name: currency.name, issuer_email: issuer_email}
  end
end
