defmodule Point.Account do
  use Point.Web, :model
  use Timex.Ecto.Timestamps, usec: true
  alias Point.{UserService, CurrencyService, DecimalUtil}

  schema "accounts" do
    field :amount, :decimal
    field :type, :string
    field :owner_email, :string, virtual: true
    field :currency_code, :string, virtual: true

    belongs_to :owner, Point.User
    belongs_to :issuer, Point.User
    belongs_to :currency, Point.Currency
    belongs_to :entity, Point.Entity

    timestamps()
  end

  # Only for test purpouse!
  def changeset(model , params \\ %{}) do
    model |> cast_and_validate_required(params, [:type, :amount, :owner_id, :issuer_id, :currency_id, :entity_id])
  end

  def insert_changeset(model , params \\ %{}) do
    model
      |> cast(params, [:type, :owner_email, :issuer_id, :currency_code, :entity_id])
      |> validate_required([:type, :owner_email, :issuer_id, :currency_code])
      |> map_from(:owner_email, to: :owner_id, resolver: &(UserService.by(email: &1)))
      |> map_from(:currency_code, to: :currency_id, resolver: &(CurrencyService.by(code: &1)))
      |> validate_required([:owner_id, :currency_id])
      |> set_default_value_to(field: :amount, value: DecimalUtil.zero)
  end

  def update_changeset(model , params \\ %{}) do
    model
      |> cast(params, [:currency_code])
      |> validate_required([:currency_code])
      |> map_from(:currency_code, to: :currency_id, resolver: &(CurrencyService.by(code: &1)))
  end
end
