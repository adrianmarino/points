defmodule Point.Transaction do
  use Point.Web, :model

  schema "transactions" do
    field :name, :string
    field :source, :string

    timestamps()
  end

  def insert_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :source])
    |> validate_required([:name, :source])
  end

  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:source])
    |> validate_required([:source])
  end
end
