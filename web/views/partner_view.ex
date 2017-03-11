defmodule Point.PartnerView do
  use Point.Web, :view
  alias Point.PartnerView
  import Point.Repo, only: [assoc: 2]

  def render("index.json", %{partners: partners}), do: render_many(partners, PartnerView, "partner.json")
  def render("show.json", %{partner: partner}), do: render_one(partner, PartnerView, "partner.json")
  def render("partner.json", %{partner: partner}) do
    %{
      code: assoc(partner, :partner).code,
      entity_code: assoc(partner, :entity).code
    }
  end
end
