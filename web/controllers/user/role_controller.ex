defmodule Point.RoleController do
  use Point.Web, :controller
  import Point.JSON
  def index(conn, _) do
    conn
     |> put_resp_header("content-type", "application/json")
     |> send_resp(:ok, to_json ~w[system_admin entity_admin normal_user])
  end
end
