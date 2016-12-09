defmodule Point.SessionController do
  use Point.Web, :controller
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias Point.{User, Session}
  import Logger

  def create(conn, %{"user" => user_params}) do
    user = Repo.get_by(User, email: user_params["email"])
    cond do
      user && checkpw(user_params["password"], user.password_hash) ->
        session_changeset = Session.create_changeset(%Session{}, %{user_id: user.id})
        {:ok, session} = Repo.insert(session_changeset)
        conn |> put_status(:created) |> render("show.json", session: session)
        info "#{user.email} sign in!"
      user ->
        conn |> put_status(:unauthorized) |> render("error.json", user_params)
        error "#{user.email} sign in fail!"
      true ->
        dummy_checkpw
        conn |> put_status(:unauthorized) |> render("error.json", user_params)
        error "#{user.email} sign in fail!"
    end
  end
end
