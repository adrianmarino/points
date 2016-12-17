defmodule Point.SessionController do
  use Point.Web, :controller
  import Logger
  import Point.Phoenix.ConnUtil
  alias Point.{SessionService, UserService}

  def index(conn, _), do: render(conn, "index.json", sessions: SessionService.all)

  def sign_in(conn, user_params) do
    user = UserService.by(email: user_params["email"])
    cond do
      user && UserService.check(that_user: user, has_password: user_params["password"]) ->
        case SessionService.open(for_user: user, from: remote_ip(conn)) do
          {:ok, session} ->
            info "#{user_params["email"]} sign in!"
            conn |> put_status(:created) |> render("show.json", session: session)
          {:error, message } ->
            warn_log user_params["email"], message
            conn |> put_status(:unauthorized) |> render("error.json", %{cause: message})
        end
      user != nil ->
        message = warn_log user_params["email"], "Invalid password"
        conn |> put_status(:unauthorized) |> render("error.json", %{cause: message})
      true ->
        UserService.dummy_check_password
        message = warn_log user_params["email"], "User not found"
        conn |> put_status(:unauthorized) |> render("error.json", %{cause: message})
    end
  end

  def sign_out(conn, _) do
    SessionService.close(token: current_session(conn).token)
    close_session(conn)
    send_resp(conn, :no_content, "")
  end

  defp warn_log(email, message) do
    warn "#{email} sign in: #{message}"
    message
  end
end
