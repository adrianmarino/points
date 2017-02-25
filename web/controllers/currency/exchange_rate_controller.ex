defmodule Point.ExchangeRateController do
  use Point.Web, :controller
  import Point.Phoenix.JSONResponseUtil
  alias Point.{ExchangeRateService, ChangesetView}

  def index(conn, _), do: render(conn, "index.json", exchange_rates: ExchangeRateService.all)

  def show(conn, %{"source" => source_code, "target" => target_code}) do
    case ExchangeRateService.by(source_code: source_code, target_code: target_code) do
      nil -> send_resp(conn, :not_found, "")
      exchange_rate -> render(conn, "show.json", exchange_rate: exchange_rate)
    end
  end

  def create(conn, %{"source" => source_code, "target" => target_code, "value" => value}) do
    case ExchangeRateService.insert(source_code: source_code, target_code: target_code, value: value) do
      {:ok, exchange_rate} ->
        conn
          |> put_status(:created)
          |> put_resp_header("localtion", exchange_rate_path(conn, :show, source_code, target_code))
          |> render("show.json", exchange_rate: exchange_rate)
      {:error, changeset} ->
        conn |> put_status(:unprocessable_entity) |> render(ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"source" => source_code, "target" => target_code}) do
    value = conn.body_params["value"]
    case ExchangeRateService.update(source_code: source_code, target_code: target_code, value: value) do
      {:ok, exchange_rate} ->
        conn
          |> put_status(:created)
          |> put_resp_header("localtion", exchange_rate_path(conn, :show, source_code, target_code))
          |> render("show.json", exchange_rate: exchange_rate)
      {:error, :not_found} -> send_resp(conn, :not_found, "")
      {:error, changeset} ->
        conn |> put_status(:unprocessable_entity) |> render(ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"source" => source_code, "target" => target_code}) do
    case ExchangeRateService.delete(source_code: source_code, target_code: target_code) do
      {:ok, _ } -> send_resp(conn, :no_content, "")
      {:error, :not_found } -> send_message_resp(conn, :not_found, "")
      {:error, message } -> send_message_resp(conn, :internal_server_error, message)
    end
  end
end
