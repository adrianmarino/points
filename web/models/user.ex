defmodule Point.User do
  use Point.Web, :model
  alias Point.{Entity, Currency}

  schema "users" do
    field :email, :string
    field :password, :string
    field :first_name, :string
    field :last_name, :string

    many_to_many :entities, Entity, join_through: "users_entities"
    has_many :currencies, Currency

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password, :first_name, :last_name])
    |> validate_required([:email, :password, :first_name, :last_name])
  end
end
