defmodule Point.AccountView do
  use Point.Web, :view
  alias Point.Repo

  def render("index.json", %{accounts: accounts}), do: render_many(accounts, Point.AccountView, "account.json")
  def render("show.json", %{account: account}), do: render_one(account, Point.AccountView, "account.json")

  def render("account.json", %{account: account}) do
    currency_code = Repo.assoc(account, :currency).code
    owner_email = Repo.assoc(account, :owner).email
    amount = to_string account.amount
    view = %{id: account.id, owner_email: owner_email, currency: currency_code, amount: amount}

    case Repo.assoc(account, :issuer) do
      nil -> view
      issuer when issuer != nil -> Map.put(view, :issuer_email, issuer.email)
    end
  end
end
