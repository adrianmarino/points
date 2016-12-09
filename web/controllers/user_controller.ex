defmodule Point.UserController do
  use Point.Web, :controller
  alias Point.{UserService, ChangesetView}

  def index(conn, _params), do: render(conn, "index.json", users: UserService.all)
  def show(conn, %{"id" => id}), do: render(conn, "show.json", user: UserService.get!(id))

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

  def update(conn, %{"id" => id, "user" => user_params}) do
    case UserService.update(id, user_params) do
      {:ok, user} -> render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
          |> put_status(:unprocessable_entity)
          |> render(ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    UserService.delete(id)
    send_resp(conn, :no_content, "")
  end
end
