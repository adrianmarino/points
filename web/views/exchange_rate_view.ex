defmodule Point.ExchangeRateView do
  use Point.Web, :view
  alias Point.{ExchangeRateView, Repo}

  def render("index.json", %{exchange_rates: exchange_rates}) do
    render_many(exchange_rates, ExchangeRateView,  "exchange_rate.json")
  end
  def render("show.json", %{exchange_rate: exchange_rate}) do
    render_one(exchange_rate, ExchangeRateView,  "exchange_rate.json")
  end
  def render("exchange_rate.json", %{exchange_rate: exchange_rate}) do
    source = Repo.assoc(exchange_rate, :source).code
    target = Repo.assoc(exchange_rate, :target).code

    %{source: source, target: target, value: exchange_rate.value}
  end
end
