defmodule Point.TransactionController do
  use Point.Web, :controller
  import Point.Phoenix.JSONResponseUtil
  import Point.Phoenix.ConnUtil
  alias Point.TransactionService

  def index(conn, _) do
    render(conn, "index.json", transactions: TransactionService.by(issuer_id: current_user_id(conn)))
  end

  def show(conn, %{"name" => name}) do
    case TransactionService.by(name: name, issuer_id: current_user_id(conn)) do
      nil -> send_resp(conn, :not_found, "")
      transaction -> render(conn, "show.json", transaction: transaction)
    end
  end

  def transfer(conn, params), do: exec(conn, :transfer, params)
  def deposit(conn, params), do: exec(conn, :deposit, params)
  def extract(conn, params), do: exec(conn, :extract, params)

  def execute(conn, %{"name" => name}) do
    case TransactionService.by(name: name, issuer_id: current_user_id(conn)) do
      nil -> send_error_resp(conn, :not_found, "")
      transaction -> exec(conn, transaction, conn.body_params)
    end
  end

  def create(conn, %{"name" => name}) do
    case body(conn) do
      {:ok, body } ->
        attrs = %{name: name, issuer_id: current_user_id(conn), source: body}
        case TransactionService.insert(attrs) do
          {:ok, transaction} ->
            conn
              |> put_status(:created)
              |> put_resp_header("location", transaction_path(conn, :show, transaction))
              |> render("show.json", transaction: transaction)
          {:error, changeset} ->
            conn
              |> put_status(:unprocessable_entity)
              |> render(Point.ChangesetView, "error.json", changeset: changeset)
        end
      {:error, message} -> send_error_resp(conn, :bad_request, message)
    end
  end

  def update(conn, %{"name" => name}) do
    case TransactionService.by(name: name, issuer_id: current_user_id(conn)) do
      nil -> send_resp(conn, :bad_request, "")
      transaction ->
        case body(conn) do
          {:ok, body } ->
            case TransactionService.update(transaction, source: body) do
              {:ok, transaction} -> render(conn, "show.json", transaction: transaction)
              {:error, changeset} ->
                conn
                  |> put_status(:unprocessable_entity)
                  |> render(Point.ChangesetView, "error.json", changeset: changeset)
            end
          {:error, message} -> send_error_resp(conn, :bad_request, message)
        end
      end
  end

  def delete(conn, %{"name" => name}) do
    case TransactionService.delete(name: name, issuer_id: current_user_id(conn)) do
      {:ok, _ } -> send_resp(conn, :no_content, "")
      {:error, message } -> send_message_resp(conn, :not_found, message)
    end
  end

  defp body(conn) do
    case Plug.Conn.read_body(conn) do
      {:ok, data, _} -> {:ok, String.trim(data)}
      _ -> {:error, "Parse request body errror!" }
    end
  end

  defp exec(conn, transaction, params) do
    case TransactionService.execute(transaction, params) do
      {:ok, result} -> send_resp(conn, :ok, to_string(result))
      {:error, error} -> send_error_resp(conn, :internal_server_error, inspect(error))
    end
  end
end
