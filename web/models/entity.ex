defmodule Point.Entity do
  @moduledoc """
  An entity has many accounts belonging to users.
  """
  use Point.Web, :model

  schema "entities" do
    field :name, :string

    many_to_many :users, Point.User, join_through: "users_entities"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
