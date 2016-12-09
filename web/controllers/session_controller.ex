defmodule Point.SessionController do
  use Point.Web, :controller
  import Logger
  alias Point.{SessionService, UserService}

  def index(conn, _), do: render(conn, "index.json", sessions: SessionService.all)

  def sign_in(conn, user_params) do
    user = UserService.by(email: user_params["email"])
    cond do
      user && UserService.check(that_user: user, has_password: user_params["password"]) ->
        {:ok, session} = SessionService.open(for_user: user)
        info "#{user_params["email"]} sign in!"
        conn |> put_status(:created) |> render("show.json", session: session)
      user ->
        error "#{user_params["email"]} sign in fail!"
        conn |> put_status(:unauthorized) |> render("error.json", user_params)
      true ->
        UserService.dummy_check_password
        error "#{user_params["email"]} sign in fail!"
        conn |> put_status(:unauthorized) |> render("error.json", user_params)
    end
  end
end
