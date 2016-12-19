defmodule Point.CurrencyController do
  use Point.Web, :controller
  import Point.Phoenix.ConnUtil
  alias Point.CurrencyService
  import Point.JSON

  def index(conn, _), do: render(conn, "index.json", currencies: CurrencyService.all)
  def show(conn, %{"code" => code}) do
    case CurrencyService.by(code: code) do
      nil -> send_resp(conn, :not_found, "")
      currency -> render(conn, "show.json", currency: currency)
    end
  end

  def create(conn, params) do
    case CurrencyService.insert(put_issuer_id(conn, to: params)) do
      {:ok, currency} ->
        conn
          |> put_status(:created)
          |> put_resp_header("location", currency_path(conn, :show, currency))
          |> render("show.json", currency: currency)
      {:error, changeset} ->
        conn
          |> put_status(:unprocessable_entity)
          |> render(Point.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"code" => code, "currency" => params}) do
    case CurrencyService.update(code, put_issuer_id(conn, to: params)) do
      {:ok, currency} -> render(conn, "show.json", currency: currency)
      {:error, changeset} ->
        conn
          |> put_status(:unprocessable_entity)
          |> render(Point.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"code" => code}) do
    case CurrencyService.delete(code) do
      {:ok, currency } -> send_resp(conn, :no_content, "")
      {:error, message } -> send_resp(conn, :not_found, to_json(%{message: message}))
    end
  end
end
