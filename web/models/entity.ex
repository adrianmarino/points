defmodule Point.Entity do
  @moduledoc """
  An entity has many accounts belonging to users.
  """
  use Point.Web, :model
  use Timex.Ecto.Timestamps, usec: true

  schema "entities" do
    field :code, :string
    field :name, :string

    has_many :accounts, Point.Account

    many_to_many :users, Point.User, join_through: "users_entities"
    many_to_many :partners, Point.Entity, join_through: Point.Partner, join_keys: [entity_id: :id, partner_id: :id]

    timestamps()
  end

  def insert_changeset(model, params \\ %{}) do
    model |> cast_and_validate_required(params, [:code, :name])
  end

  def update_changeset(model, params \\ %{}), do: model |> cast_and_validate_required(params, [:name])
end
