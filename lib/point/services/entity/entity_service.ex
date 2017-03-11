defmodule Point.EntityService do
  alias Point.{Entity, Repo, UserService, AccountService, PartnerService}

  def add_partner(entity, partner), do: PartnerService.insert!(entity, partner)
  def remove_partner(entity, partner), do: PartnerService.delete!(entity, partner)

  def all, do: Repo.all(Entity)

  def insert(params), do: Repo.insert(insert_changeset params)

  def insert!(params), do: Repo.insert!(insert_changeset params)

  def update(code, params), do: Repo.update(Entity.update_changeset(by(code: code), params))

  def by(code: code), do: Repo.get_by(Entity, code: code)

  def delete(code) do
    case by(code: code) do
      nil -> {:error, :not_found, "Not found entity"}
      entity ->
        entity = load(entity, :partners)
        case entity.partners do
          partners when length(partners) > 0 ->
            names = partners |> Enum.map(&(&1.name))
            {:error, :has_partners, "The entity have #{names} partners"}
          [] ->
            case AccountService.count_by(entity: entity) do
              accounts_count when accounts_count > 0 ->
                {:error, :has_accounts, "The entity have #{accounts_count} accounts"}
              0 ->
                case UserService.count_by(entity: entity) do
                  users_count when users_count > 0 -> {:error, :has_partners, "The entity have #{users_count} users"}
                  0 -> Repo.delete(entity)
                end
            end
        end
    end
  end

  def load(entity, field), do: entity |> Repo.preload(field)

  defp insert_changeset(params), do: Entity.insert_changeset(%Entity{}, params)
end
