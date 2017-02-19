defmodule Point.PartnerService do
  alias Point.{Repo, Partner}

  def insert!(entity, partner), do: Repo.insert!(%Partner{entity: entity, partner: partner})

  def delete!(entity, partner) do
    paetner = Repo.get_by(Partner, entity_id: entity.id, partner_id: partner.id)
    Repo.delete!(paetner)
  end
end
