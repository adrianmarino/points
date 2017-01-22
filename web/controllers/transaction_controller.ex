defmodule Point.TransactionController do
  use Point.Web, :controller
  import Point.Phoenix.JSONResponseUtil
  alias Point.{Model, TransactionService}

  def index(conn, _), do: render(conn, "index.json", transactions: TransactionService.all)

  def show(conn, %{"name" => name}) do
    case TransactionService.by(name: name) do
      nil -> send_resp(conn, :not_found, "")
      transaction -> render(conn, "show.json", transaction: transaction)
    end
  end

  def execute(conn, %{"name" => name}) do
    case TransactionService.by(name: name) do
      nil -> send_error_resp(conn, :not_found, "")
      transaction ->
        case TransactionService.execute(transaction, conn.body_params) do
          {:ok, result } -> send_resp(conn, :ok, Model.to_string(result))
          {:error, error} -> send_error_resp(conn, :internal_server_error, inspect(error))
        end
    end
  end

  def create(conn, %{"name" => name}) do
    case body(conn) do
      {:ok, body } ->
        case TransactionService.insert(name: name, source: body) do
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
    case TransactionService.by(name: name) do
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
    case TransactionService.delete(name: name) do
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
end
