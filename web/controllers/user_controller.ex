defmodule Point.UserController do
  use Point.Web, :controller
  alias Point.{UserService, ChangesetView}

  def index(conn, _params), do: render(conn, "index.json", users: UserService.all)

  def show(conn, %{"email" => email}), do: render(conn, "show.json", user: UserService.by(email: email))

  def create(conn, user_params) do
    case UserService.register(user_params) do
      {:ok, user} ->
        conn
          |> put_status(:created)
          |> put_resp_header("location", user_path(conn, :show, user))
          |> render("show.json", user: user)
      {:error, changeset} ->
        conn
          |> put_status(:unprocessable_entity)
          |> render(ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"email" => email}) do
    case UserService.update(email, conn.body_params) do
      {:ok, user} -> render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
          |> put_status(:unprocessable_entity)
          |> render(ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"email" => email}) do
    UserService.delete!(email: email)
    send_resp(conn, :no_content, "")
  end
end
