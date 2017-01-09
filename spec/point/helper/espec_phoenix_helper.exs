defmodule ESpec.Phoenix.Helper do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      import Point.Phoenix.ConnUtil

      alias Point.{Repo, Session, User}

      let :current_user do
        Repo.insert! User.registration_changeset(%User{}, %{
          email: "session_test_user@gmail.com",
          password: "Whatever10",
          first_name: "Test",
          last_name: "User"
        })
      end

      let current_session: Repo.insert!(%Session{token: "token", remote_ip: "127.0.0.1", user_id: current_user.id})

      let session_token: current_session.token
    end
  end

  defmacro sec_conn do
    quote do: build_conn |> put_token_in_header(current_session.token)
  end

  defmacro remote_ip(conn, ip) do
    quote bind_quoted: [conn: conn, ip: ip] do
      put_req_header(conn, "x-forwarded-for", ip)
    end
  end

  defmacro text_plain, do: "text/plain"
  defmacro application_json, do: "application/json"

  defmacro content_type(conn, value) do
    quote bind_quoted: [conn: conn, value: value], do: put_req_header(conn, "content-type", value)
  end

  defmacro put_token_in_header(conn, token) do
    quote bind_quoted: [conn: conn, token: token] do
      conn |> put_req_header("token", token)
    end
  end
end
