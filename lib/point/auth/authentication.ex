defmodule Point.Authentication do
  import Plug.Conn
  import Ecto.Query, only: [from: 2]
  import Point.Repo
  alias Point.{User, Session}

  def init(options), do: options

  def call(conn, _) do
    case find_user(conn) do
      {:ok, user} -> assign(conn, :current_user, user)
      _  -> auth_error!(conn)
    end
  end

  defp find_user(conn) do
    with auth_header = get_req_header(conn, "token"),
         {:ok, token}   <- parse_token(auth_header),
         {:ok, session} <- find_session_by_token(token),
    do: find_user_by_session(session)
  end

  defp parse_token([token]), do: {:ok, token}
  defp parse_token([]), do: :error

  defp find_session_by_token(token) do
    case one(from s in Session, where: s.token == ^token) do
      nil     -> :error
      session -> {:ok, session}
    end
  end

  defp find_user_by_session(session) do
    case get(User, session.user_id) do
      nil  -> :error
      user -> {:ok, user}
    end
  end

  defp auth_error!(conn), do: conn |> put_status(:unauthorized) |> halt()
end
