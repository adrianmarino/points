defmodule Point.MovementController do
  use Point.Web, :controller
  import Point.Phoenix.JSONResponseUtil
  alias Point.{MovementSearcher, AccountService}

  @timestamp_format "{YYYY}{0M}{0D}_{h24}{m}"

  def search_after(conn, %{"after" => str_timestamp}) do
    case to_timestamp(str_timestamp) do
      {:error, _} -> send_resp(conn, :bad_request, "Invalid after value. must be YYYYMMDD_HHMM.")
      timestamp ->
        case MovementSearcher.search(after: timestamp) do
          [] -> send_resp(conn, :not_found, "")
          movements -> render(conn, "index.json", movements: movements)
        end
    end
  end

  def search_by_account_after(conn, %{"owner_email" => owner_email, "currency_code" => currency_code,
    "after" => str_timestamp}) do
    case to_timestamp(str_timestamp) do
      {:error, _} -> send_resp(conn, :bad_request, "Invalid after value. must be YYYYMMDD_HHMM.")
      timestamp ->
        case AccountService.by(email: owner_email, currency_code: currency_code) do
          nil -> send_message_resp(conn, :not_found, "Not found account")
          account ->
            case MovementSearcher.search(for: account, after: timestamp) do
              [] -> send_resp(conn, :not_found, "")
              movements -> render(conn, "search.json", movements: movements, account_id: account.id)
            end
        end
    end
  end

  def to_timestamp(value), do: Timex.parse!(value, @timestamp_format)
end
