defmodule Point.Currency do
  use Point.Web, :model
  use Timex.Ecto.Timestamps, usec: true

  schema "currencies" do
    field :code, :string
    field :name, :string

    belongs_to :issuer, Point.User

    timestamps
  end

  def insert_changeset(model, params \\ %{}) do
    model |> cast_and_validate_required(params, [:code, :name, :issuer_id])
  end
  def update_changeset(model, params \\ %{}), do: model |> cast_and_validate_required(params, [:name])
end
