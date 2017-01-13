defmodule Point.Transaction do
  use Point.Web, :model

  schema "transactions" do
    field :name, :string
    field :source, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :source])
    |> validate_required([:name, :source])
  end
end
