defmodule Point.Transaction do
  use Point.Web, :model
  use Timex.Ecto.Timestamps, usec: true

  schema "transactions" do
    field :name, :string
    field :source, :string

    belongs_to :issuer, Point.User

    timestamps
  end

  def insert_changeset(model, params \\ %{}) do
    model |> cast_and_validate_required(params, [:name, :source, :issuer_id])
  end
  def update_changeset(model, params \\ %{}), do: model |> cast_and_validate_required(params, [:source])
end
