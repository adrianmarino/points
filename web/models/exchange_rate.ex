defmodule Point.ExchangeRate do
  @moduledoc """
  Allow convert an amount between to correncies.
  """
  alias Point.{DecimalUtil, CurrencyService}
  import Point.EctoModel

  def inverse(rate), do: DecimalUtil.inverse(rate.value)

  use Point.Web, :model

  schema "exchange_rates" do
    field :value, :decimal
    field :source_code, :string, virtual: true
    field :target_code, :string, virtual: true

    belongs_to :source, Point.Currency
    belongs_to :target, Point.Currency

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:value, :source, :target])
    |> validate_required([:value, :source, :target])
  end

  def insert_changeset(model, params \\ %{}) do
    model
      |> cast(params, [:value, :source_code, :target_code])
      |> validate_required([:value, :source_code, :target_code])
      |> map_from(:source_code, to: :source_id, resolver: &(CurrencyService.by(code: &1)))
      |> map_from(:target_code, to: :target_id, resolver: &(CurrencyService.by(code: &1)))
  end

  def update_changeset(model , params \\ %{}), do: model |> cast(params, [:value]) |> validate_required([:value])
end
