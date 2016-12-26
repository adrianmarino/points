defprotocol Point.Model do
  def changeset(model, fields)
  def to_map(model)
  def refresh(model)
  def to_string(model)
end

defimpl Point.Model, for: Point.Movement do
  import Point.Repo
  alias Point.Movement
  alias Point.Model

  def changeset(model, fields), do: Movement.changeset(model, fields)
  def to_map(model) do
    %{
      type: model.type,
      source: account_to_map(model, :source),
      target: account_to_map(model, :target),
      amount: Decimal.to_string(model.amount),
    }
  end
  def to_string(model), do: inspect(to_map model)
  def refresh(model), do: get_by(Movement, id: model.id)

  defp account_to_map(movement, field) do
    case assoc(movement, field) do
      nil -> "non"
      account -> Model.to_map(account)
    end
  end
end


defimpl Point.Model, for: Point.Account do
  import Point.Repo
  alias Point.Account

  def changeset(model, fields), do: Account.changeset(model, fields)
  def to_map(model), do: "#{assoc(model, :currency).code} #{Decimal.to_string model.amount}"
  def to_string(model), do: inspect(to_map model)
  def refresh(model), do: get_by(Account, id: model.id)
end

defimpl Point.Model, for: Point.Currency do
  import Point.Repo
  alias Point.Currency

  def changeset(model, fields), do: Point.Currency.changeset(model, fields)
  def to_map(model), do: model.code
  def to_string(model), do: inspect(to_map model)
  def refresh(model), do: get_by(Currency, id: model.id)
end

defimpl Point.Model, for: Point.Entity do
  import Point.Repo
  alias Point.Entity

  def changeset(model, fields), do: Entity.changeset(model, fields)
  def to_map(model), do: model.name
  def to_string(model), do: inspect(to_map model)
  def refresh(model), do: get_by(Entity, id: model.id)
end

defimpl Point.Model, for: Point.ExchangeRate do
  import Point.Repo
  alias Point.ExchangeRate
  alias Point.Model

  def changeset(model, fields), do: ExchangeRate.changeset(model, fields)
  def to_map(model), do: %{
    value: Decimal.to_string(model.value),
    source: Model.to_map(assoc(model, :source)),
    target: Model.to_map(assoc(model, :target))
  }
  def to_string(model), do: inspect(to_map model)
  def refresh(model), do: get_by(ExchangeRate, id: model.id)
end

defimpl Point.Model, for: Point.User do
  import Point.Repo
  alias Point.User

  def changeset(model, fields), do: User.changeset(model, fields)
  def to_map(model), do: model.email
  def to_string(model), do: inspect(to_map model)
  def refresh(model), do: get_by(User, id: model.id)
end
