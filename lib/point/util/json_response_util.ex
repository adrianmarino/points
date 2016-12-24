defmodule Point.Phoenix.JSONResponseUtil do
  import Point.JSON

  defmacro send_message_resp(conn, status, message) do
    quote do
      send_resp(
        unquote(conn),
        unquote(status),
        to_json(%{message: unquote(message)})
      )
    end
  end
end
