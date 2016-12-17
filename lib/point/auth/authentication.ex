defmodule Point.Authentication do
  import Plug.Conn
  alias Point.SessionService

  def init(options), do: options

  def call(conn, _) do
    case find_session(conn) do
      {:ok, session} -> assign(conn, :current_session, session)
      _  -> auth_error!(conn)
    end
  end

  defp find_session(conn) do
    with auth_header = get_req_header(conn, "token"),
         {:ok, token}   <- parse_token(auth_header),
    do: find_session_by(token: token)
  end

  defp parse_token([token]), do: {:ok, token}
  defp parse_token([]), do: :error

  defp find_session_by(token: token) do
    case SessionService.by(token: token) do
      nil -> :error
      session -> {:ok, session}
    end
  end

  defp auth_error!(conn) do
    {:ok, response_body } = Poison.encode(%{message: "Session expired"})
    send_resp(conn, :unauthorized, response_body) |> halt
  end
end
