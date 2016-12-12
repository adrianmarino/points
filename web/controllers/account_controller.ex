defmodule Point.AccountController do
  use Point.Web, :controller
  alias Point.AccountService

  def index(conn, _), do: render(conn, "index.json", accounts: AccountService.all)
  def show(conn, %{"id" => id}), do: render(conn, "show.json", account: AccountService.get!(id))

  def create(conn, account_params) do
    case AccountService.insert(add_issuer_id(conn, account_params)) do
      {:ok, account} ->
        conn
          |> put_status(:created)
          |> put_resp_header("location", account_path(conn, :show, account))
          |> render("show.json", account: account)
      {:error, changeset} ->
        conn
          |> put_status(:unprocessable_entity)
          |> render(Point.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    case AccountService.update(id , add_issuer_id(conn, account_params)) do
      {:ok, account} -> render(conn, "show.json", account: account)
      {:error, changeset} ->
        conn
          |> put_status(:unprocessable_entity)
          |> render(Point.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    AccountService.delete!(id)
    send_resp(conn, :no_content, "")
  end

  defp add_issuer_id(conn, params), do: Map.put(params, "issuer_id", conn.assigns.current_user.id)
end
