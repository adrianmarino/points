defmodule Point.Currency do
  use Point.Web, :model
  import Point.EctoModel

  schema "currencies" do
    field :code, :string
    field :name, :string

    belongs_to :issuer, Point.User

    timestamps()
  end

  def changeset(model, params \\ %{}), do: model |> cast_and_validate_required(params, [:code, :name, :issuer_id])
end
