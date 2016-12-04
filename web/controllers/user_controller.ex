defmodule Point.UserController do
  use Point.Web, :controller

  alias Point.User
  import Repo

  def index(conn, _params), do: render(conn, "index.json", users: all(User))
  def show(conn, %{"id" => id}), do: render(conn, "show.json", user: get!(User, id))

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Point.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    changeset = User.changeset(get!(User, id), user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Point.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    delete!(get!(User, id))
    send_resp(conn, :no_content, "")
  end
end
