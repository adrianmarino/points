defmodule Point.PartnerService do
  import Ecto.Query
  import Point.Partner
  alias Point.{Repo, Partner, Entity}

  def insert(params), do: Repo.insert(changeset %Partner{}, params)
  def insert!(entity, partner), do: Repo.insert!(changeset %Partner{}, %{code: partner.code, entity_code: entity.code})

  def delete!(entity, partner), do: Repo.delete!(by(entity: entity, partner: partner))

  def delete(code: code, entity_code: entity_code) do
    case by(code: code, entity_code: entity_code) do
      nil -> {:error, :not_found}
      assoc -> Repo.delete(assoc)
    end
  end

  def by(entity: entity, partner: partner), do: Repo.get_by(Partner, entity_id: entity.id, partner_id: partner.id)
  def by(code: code, entity_code: entity_code) do
    Repo.one(
      from ep in Partner,
      join: e in Entity,
      join: p in Entity,
      where: ep.partner_id == p.id and p.code == ^code and ep.entity_id == e.id and e.code == ^entity_code
    )
  end
  def by(entity_code: entity_code) do
    Repo.all(from p in Partner, join: e in Entity, where: p.entity_id == e.id and e.code == ^entity_code)
  end
end
