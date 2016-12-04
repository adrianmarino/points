defmodule Point.ExchangeRate do
  @moduledoc """
  Allow comvert an amount between to correncies.
  """
  alias Point.DecimalUtil

  def inverse(rate), do: DecimalUtil.inverse(rate.value)

  use Point.Web, :model

  schema "exchange_rates" do
    field :value, :decimal

    belongs_to :source, Point.Currency
    belongs_to :target, Point.Currency

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:value, :source, :target])
    |> validate_required([:value, :source, :target])
  end
end
