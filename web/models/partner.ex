defmodule Point.Partner do
  use Point.Web, :model
  alias Point.EntityService

  schema "partners" do
    field :code, :string, virtual: true
    field :entity_code, :string, virtual: true

    belongs_to :entity, Point.Entity
    belongs_to :partner, Point.Entity

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
      |> cast_and_validate_required(params, [:code, :entity_code])
      |> map_from(:code, to: :partner_id, resolver: &(EntityService.by(code: &1)))
      |> map_from(:entity_code, to: :entity_id, resolver: &(EntityService.by(code: &1)))
      |> validate_required([:partner_id, :entity_id])
  end
end
