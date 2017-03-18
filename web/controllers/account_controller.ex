defmodule Point.AccountController do
  use Point.Web, :controller
  import Point.Phoenix.ConnUtil
  import Point.Phoenix.JSONResponseUtil
  alias Point.{AccountService, ChangesetView}

  def index(conn, _), do: render(conn, "index.json", accounts: AccountService.all)

  def show(conn, %{"owner_email" => owner_email, "currency_code" => currency_code}) do
    render(conn, "show.json", account: AccountService.by(email: owner_email, currency_code: currency_code))
  end

  def create(conn, params) do
    case AccountService.insert(put_issuer_and_entity_id(conn, to: params)) do
      {:ok, account} ->
        conn
          |> put_status(:created)
          |> put_resp_header("location", account_path(conn, :show, account.owner_email, account.currency_code))
          |> render("show.json", account: account)
      {:error, changeset} ->
        conn
          |> put_status(:unprocessable_entity)
          |> render(ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"owner_email" => owner_email, "currency_code" => currency_code}) do
    case AccountService.delete(owner_email: owner_email, currency_code: currency_code) do
      {:ok, _ } -> send_resp(conn, :no_content, "")
      {:error, message } -> send_message_resp(conn, :not_found, message)
    end
  end
end
