defmodule Point.TransactionController do
  use Point.Web, :controller
  import Point.Phoenix.JSONResponseUtil
  alias Point.{Model, TransactionService}

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
          {:ok, _} -> send_resp(conn, :created, "")
          {:error, message} -> send_error_resp(conn, :bad_request, message)
        end
      {:error, message} -> send_error_resp(conn, :bad_request, message)
    end
  end

  defp body(conn) do
    case Plug.Conn.read_body(conn) do
      {:ok, data, _} -> {:ok, String.trim(data)}
      _ -> {:error, "Parse request body errror!" }
    end
  end
end
