defmodule ESpec.Phoenix.Helper do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      import Point.Phoenix.ConnUtil

      alias Point.{Repo, Session, User}

      let! :session_token do
        user = Repo.insert! User.registration_changeset(%User{}, %{
          email: "session_test_user@gmail.com",
          password: "Whatever10",
          first_name: "Test",
          last_name: "User"
        })

        session = Repo.insert!(%Session{
          token: "token",
          remote_ip: "127.0.0.1",
          user_id: user.id
        })
        session.token
      end
    end
  end

  defmacro sec_conn do
    quote do: build_conn |> put_token_in_header(session_token)
  end

  defmacro put_remote_ip_in_header(conn, ip) do
    quote do: put_req_header(unquote(conn), "x-forwarded-for", unquote(ip))
  end

  defmacro put_app_json_in_header(conn), do: quote do: put_req_header(unquote(conn), "accept", "application/json")

  defmacro put_token_in_header(conn, token) do
    quote do: unquote(conn) |> put_req_header("token", unquote(token))
  end
end
