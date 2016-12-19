defmodule Point.Currency do
  use Point.Web, :model

  schema "currencies" do
    field :code, :string
    field :name, :string

    belongs_to :issuer, Point.User

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
      |> cast(params, [:code, :name, :issuer_id])
      |> validate_required([:code, :name, :issuer_id])
  end
end
