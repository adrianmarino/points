defmodule Point.Account do
  use Point.Web, :model

  schema "accounts" do
    field :amount, :decimal
    field :type, :string

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
    |> cast(params, [:type, :amount, :owner_id, :issuer_id, :currency_id])
    |> validate_required([:type, :amount, :owner_id, :issuer_id, :currency_id])
  end
end
