defmodule Point.Account do
  use Point.Web, :model
  alias Point.{UserService, CurrencyService, DecimalUtil}
  import Point.ModelUtil

  schema "accounts" do
    field :amount, :decimal
    field :type, :string
    field :owner_email, :string, virtual: true
    field :currency_code, :string, virtual: true

    belongs_to :owner, Point.User
    belongs_to :issuer, Point.User
    belongs_to :currency, Point.Currency

    timestamps()
  end

  # Only for test purpouse!
  def changeset(model , params \\ %{}) do
    model
      |> cast(params, [:type, :amount, :owner_id, :issuer_id, :currency_id])
      |> validate_required([:type, :amount, :owner_id, :issuer_id, :currency_id])
  end

  def insert_changeset(model , params \\ %{}) do
    model
      |> cast(params, [:type, :owner_email, :issuer_id, :currency_code])
      |> validate_required([:type, :owner_email, :issuer_id, :currency_code])
      |> map_from(:owner_email, to: :owner_id, resolver: &(UserService.by(email: &1)))
      |> map_from(:currency_code, to: :currency_id, resolver: &(CurrencyService.by(code: &1)))
      |> set_default_value_to(field: :amount, value: DecimalUtil.zero)
  end

  def update_changeset(model , params \\ %{}) do
    model
      |> cast(params, [:currency_code])
      |> validate_required([:currency_code])
      |> map_from(:currency_code, to: :currency_id, resolver: &(CurrencyService.by(code: &1)))
  end
end
