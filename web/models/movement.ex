defmodule Point.Movement do
  @moduledoc """
  Represent an amount trans
  """
  use Point.Web, :model
  use Timex.Ecto.Timestamps, usec: true

  schema "movements" do
    field :type, :string
    field :amount, :decimal
    field :rate, :decimal

    belongs_to :source, Point.Account
    belongs_to :target, Point.Account

    timestamps
  end

  def changeset(model, params \\ %{}), do: model |> cast_and_validate_required(params, [:type, :amount])
end
