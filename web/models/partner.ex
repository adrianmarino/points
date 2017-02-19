defmodule Point.Partner do
  use Point.Web, :model

  schema "partners" do
    belongs_to :entity, Point.Entity
    belongs_to :partner, Point.Entity

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model |> cast_and_validate_required(params, [:entity_id, :partner_id])
  end
end
