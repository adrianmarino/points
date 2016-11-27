defmodule Point.Movement do
  use Point.Web, :model
  alias Point.Account

  schema "movements" do
    field :type, :string
    field :amount, :decimal
    field :rate, :decimal

    belongs_to :source, Account
    belongs_to :target, Account

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:type, :amount, :exchange_rate])
    |> validate_required([:type, :amount, :exchange_rate])
  end
end
