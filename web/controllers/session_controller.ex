defmodule Point.SessionController do
  use Point.Web, :controller
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias Point.{User, Session}
  import Logger

  def sign_in(conn, user_params) do
    user = Repo.get_by(User, email: user_params["email"])
    cond do
      user && checkpw(user_params["password"], user.password_hash) ->
        session_changeset = Session.create_changeset(%Session{}, %{user_id: user.id})
        {:ok, session} = Repo.insert(session_changeset)
        info "#{user_params["email"]} sign in!"
        conn |> put_status(:created) |> render("show.json", session: session)
      user ->
        error "#{user_params["email"]} sign in fail!"
        conn |> put_status(:unauthorized) |> render("error.json", user_params)
      true ->
        dummy_checkpw
        error "#{user_params["email"]} sign in fail!"
        conn |> put_status(:unauthorized) |> render("error.json", user_params)
    end
  end
end
