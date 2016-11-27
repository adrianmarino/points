defmodule Point.Currency do
  use Point.Web, :model

  schema "currencies" do
    field :code, :string
    field :name, :string

    belongs_to :issuer, Point.User
    has_many :accounts, Point.Account

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:code, :name, :issuer])
    |> validate_required([:code, :name, :issuer])
  end
end
