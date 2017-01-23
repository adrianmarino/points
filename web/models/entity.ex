defmodule Point.Entity do
  @moduledoc """
  An entity has many accounts belonging to users.
  """
  use Point.Web, :model
  import Point.EctoModel

  schema "entities" do
    field :name, :string

    many_to_many :users, Point.User, join_through: "users_entities"
    has_many :accounts, Point.Account

    timestamps()
  end

  def changeset(model, params \\ %{}), do: model |> cast_and_validate_required(params, [:name])
end
