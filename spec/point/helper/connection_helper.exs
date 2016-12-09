defmodule ConnectionHelper do
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      alias Point.{Repo, Session, User}

      let current_user: Repo.insert!(%User{})
      let current_session: Repo.insert!(%Session{token: "token", user_id: current_user.id})
    end
  end

  defmacro put_app_json_in_header(conn), do: quote do: put_req_header(unquote(conn), "accept", "application/json")

  defmacro put_token_in_header(conn, token) do
    quote do: unquote(conn) |> put_req_header("token", unquote(token))
  end
end
