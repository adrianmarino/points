defmodule Point.TransactionView do
  use Point.Web, :view
  alias Point.TransactionView

  def render("index.json", %{transactions: transactions}) do
    render_many(transactions, TransactionView, "transaction.json")
  end
  def render("show.json", %{transaction: transaction}) do
    render_one(transaction, TransactionView, "transaction.json")
  end
  def render("transaction.json", %{transaction: transaction}) do
    %{name: transaction.name, source: transaction.source}
  end
end
