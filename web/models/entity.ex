defmodule Point.Entity do
  use Point.Web, :model
  alias Point.User

  schema "entities" do
    field :name, :string

    many_to_many :users, User, join_through: "users_entities"

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
