defmodule Point.Phoenix.JSONResponseUtil do
  import Point.JSON

  defmacro send_message_resp(conn, status, message) do
    quote bind_quoted: [conn: conn, status: status, message: message] do
      send_resp(conn, status, to_json(%{message: message}))
    end
  end
end
