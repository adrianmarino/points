defprotocol Point.Model do
  def changeset(model, fields)
  def to_string(model)
  def refresh(model)
end

defimpl Point.Model, for: Point.Movement do
  import Point.Repo
  alias Point.Movement

  def changeset(model, fields), do: Movement.changeset(model, fields)
  def to_string(model) do
    inspect %{
      type: model.type,
      source: owner_email(model, :source),
      target: owner_email(model, :target),
      amount: Decimal.to_string(model.amount),
    }
  end
  def refresh(model), do: get_by(Movement, id: model.id)

  defp owner_email(movement, field) do
    case assoc(movement, field) do
      nil -> "non"
      account -> assoc(account, :owner).email
    end
  end
end


defimpl Point.Model, for: Point.Account do
  import Point.Repo
  alias Point.Account

  def changeset(model, fields), do: Account.changeset(model, fields)
  def to_string(model) do
    inspect %{
      amount: Decimal.to_string(model.amount),
      owner: assoc(model, :owner).email,
      issuer: assoc(model, :issuer).email,
      currency: assoc(model, :currency).name
    }
  end
  def refresh(model), do: get_by(Account, id: model.id)
end

defimpl Point.Model, for: Point.Currency do
  import Point.Repo
  alias Point.Currency

  def changeset(model, fields), do: Point.Currency.changeset(model, fields)
  def to_string(_), do: raise "indefined!"
  def refresh(model), do: get_by(Currency, id: model.id)
end

defimpl Point.Model, for: Point.Entity do
  import Point.Repo
  alias Point.Entity

  def changeset(model, fields), do: Entity.changeset(model, fields)
  def to_string(_), do: raise "indefined!"
  def refresh(model), do: get_by(Entity, id: model.id)
end

defimpl Point.Model, for: Point.ExchangeRate do
  import Point.Repo
  alias Point.ExchangeRate

  def changeset(model, fields), do: ExchangeRate.changeset(model, fields)
  def to_string(_), do: raise "indefined!"
  def refresh(model), do: get_by(ExchangeRate, id: model.id)
end

defimpl Point.Model, for: Point.User do
  import Point.Repo
  alias Point.User

  def changeset(model, fields), do: User.changeset(model, fields)
  def to_string(_), do: raise "indefined!"
  def refresh(model), do: get_by(User, id: model.id)
end
