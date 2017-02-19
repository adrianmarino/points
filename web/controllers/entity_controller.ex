defmodule Point.EntityController do
  use Point.Web, :controller
  import Point.Phoenix.JSONResponseUtil
  alias Point.{EntityService, ChangesetView}

  def index(conn, _), do: render(conn, "index.json", entities: EntityService.all)
  def show(conn, %{"code" => code}) do
    case EntityService.by(code: code) do
      nil -> send_resp(conn, :not_found, "")
      entity -> render(conn, "show.json", entity: entity)
    end
  end

  def create(conn, params) do
    case EntityService.insert(params) do
      {:ok, entity} ->
        conn
          |> put_status(:created)
          |> put_resp_header("location", entity_path(conn, :show, entity))
          |> render("show.json", entity: entity)
      {:error, changeset} -> change_error_resp(conn, changeset)
    end
  end

  def update(conn, %{"code" => code}) do
    case EntityService.update(code, conn.body_params) do
      {:ok, entity} -> render(conn, "show.json", entity: entity)
      {:error, changeset} -> change_error_resp(conn, changeset)
    end
  end

  def delete(conn, %{"code" => code}) do
    case EntityService.delete(code) do
      {:ok, _ } -> send_resp(conn, :no_content, "")
      {:error, :not_found, message} -> send_message_resp(conn, :not_found, message)
      {:error, _, message} -> send_message_resp(conn, :locked, message)
    end
  end

  defp change_error_resp(conn, changeset) do
    conn
      |> put_status(:unprocessable_entity)
      |> render(ChangesetView, "error.json", changeset: changeset)
  end
end
