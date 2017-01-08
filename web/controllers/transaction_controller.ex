defmodule Point.TransactionController do
  use Point.Web, :controller
  import Point.JSON
  alias Point.{Model, TransactionService}

  def perform(conn, %{"name" => name}) do
    case TransactionService.execute(name, conn.body_params) do
      {:ok, result } -> ok(conn, result)
      {:error, e} -> error(conn, e)
    end
  end

  defp ok(conn, result), do: send_resp(conn, :ok, Model.to_string(result))
  defp error(conn, error),do: send_resp(conn, :internal_server_error, to_json(%{error: error.message}))
end
