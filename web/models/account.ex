defmodule Point.Account do
  use Point.Web, :model

  schema "accounts" do
    field :amount, :decimal

    belongs_to :owner, Point.User
    belongs_to :issuer, Point.User
    belongs_to :currency, Point.Currency

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:amount, :owner, :issuer, :currency])
    |> validate_required([:amount, :owner, :issuer, :currency])
  end
end
