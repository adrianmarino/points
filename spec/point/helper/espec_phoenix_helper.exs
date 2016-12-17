defmodule ESpec.Phoenix.Helper do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      alias Point.{Repo, Session, User}

      let current_user: Repo.insert!(%User{})
      let current_session: Repo.insert!(%Session{token: "token", user_id: current_user.id})
    end
  end

  defmacro sec_conn do
    quote do
      build_conn |> put_token_in_header(current_session.token)
    end
  end

  defmacro put_remote_ip_in_header(conn, ip) do
    quote do: put_req_header(unquote(conn), "x-forwarded-for", unquote(ip))
  end

  defmacro put_app_json_in_header(conn), do: quote do: put_req_header(unquote(conn), "accept", "application/json")

  defmacro put_token_in_header(conn, token) do
    quote do: unquote(conn) |> put_req_header("token", unquote(token))
  end
end
