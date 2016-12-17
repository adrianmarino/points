defmodule Point.Account do
  use Point.Web, :model
  alias Point.{UserService, CurrencyService}
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

  def save_changeset(model , params \\ %{}) do
    model
      |> cast(params, [:type, :amount, :owner_email, :issuer_id, :currency_code])
      |> validate_required([:type, :amount, :owner_email, :issuer_id, :currency_code])
      |> map_from(:owner_email, to: :owner_id, resolver: &(UserService.by(email: &1)))
      |> map_from(:currency_code, to: :currency_id, resolver: &(CurrencyService.by(code: &1)))
  end
end
