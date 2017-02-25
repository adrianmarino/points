defmodule Point.ExchangeRate do
  @moduledoc """
  Allow convert an amount between to correncies.
  """
  use Point.Web, :model
  use Timex.Ecto.Timestamps, usec: true
  alias Point.{DecimalUtil, CurrencyService}

  def inverse(rate), do: DecimalUtil.inverse(rate.value)

  schema "exchange_rates" do
    field :value, :decimal
    field :source_code, :string, virtual: true
    field :target_code, :string, virtual: true

    belongs_to :source, Point.Currency
    belongs_to :target, Point.Currency

    timestamps
  end

  def changeset(model, params \\ %{}) do
    model |> cast_and_validate_required(params, [:value, :source_id, :target_id])
  end

  def insert_changeset(model, params \\ %{}) do
    model
      |> cast(params, [:value, :source_code, :target_code])
      |> validate_required([:value, :source_code, :target_code])
      |> map_from(:source_code, to: :source_id, resolver: &(CurrencyService.by(code: &1)))
      |> map_from(:target_code, to: :target_id, resolver: &(CurrencyService.by(code: &1)))
      |> validate_required([:source_id, :target_id])
  end

  def update_changeset(model , params \\ %{}), do: model |> cast_and_validate_required(params, [:value])
end
