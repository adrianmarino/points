defmodule Point.Entity do
  @moduledoc """
  An entity has many accounts belonging to users.
  """
  use Point.Web, :model
  use Timex.Ecto.Timestamps, usec: true
  alias Point.Partner

  schema "entities" do
    field :name, :string

    has_many :accounts, Point.Account

    many_to_many :users, Point.User, join_through: "users_entities"
    many_to_many :partners, Point.Entity, join_through: Partner, join_keys: [entity_id: :id, partner_id: :id]

    timestamps()
  end

  def changeset(model, params \\ %{}), do: model |> cast_and_validate_required(params, [:name, :partner_id])
end
