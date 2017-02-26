defmodule Point.PartnerController do
  use Point.Web, :controller
  alias Point.PartnerService

  def create(conn, params) do
    case PartnerService.insert(params) do
      {:ok, partner} -> conn |> put_status(:created) |> render("show.json", partner: partner)
      {:error, :not_found} -> send_resp(conn, :not_found, "")
    end
  end

  def index(conn, %{"entity_code" => entity_code}) do
    render(conn, "index.json", partners: PartnerService.by(entity_code: entity_code))
  end

  def delete(conn, %{"code" => code, "entity_code" => entity_code}) do
    case PartnerService.delete(code: code, entity_code: entity_code) do
      {:error, :not_found} -> send_resp(conn, :not_found, "")
      {:ok, _ } -> send_resp(conn, :no_content, "")
    end
  end
end
