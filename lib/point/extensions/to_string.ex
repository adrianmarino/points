import Kernel, except: [to_string: 1]

# Basic types
defimpl String.Chars, for: Tuple do
  def to_string(value) do
    case value do
      {:ok, value} -> Point.Model.to_string(value)
      value -> to_string value
    end
  end
end
defimpl String.Chars, for: Map do
  alias Point.JSON
  def to_string(value), do: JSON.to_pretty_json(value)
end
defimpl String.Chars, for: Decimal do
  def to_string(value), do: Decimal.to_string(Decimal.round(value, 2))
end

# Domain types
defimpl String.Chars, for: Point.Currency, do: def to_string(model), do: Point.Model.to_string(model)
defimpl String.Chars, for: Point.Entity, do: def to_string(model), do: Point.Model.to_string(model)
defimpl String.Chars, for: Point.User, do: def to_string(model), do: Point.Model.to_string(model)
defimpl String.Chars, for: Point.Movement, do: def to_string(model), do: Point.Model.to_string(model)
defimpl String.Chars, for: Point.Account, do: def to_string(model), do: Point.Model.to_string(model)
defimpl String.Chars, for: Point.ExchangeRate, do: def to_string(model), do: Point.Model.to_string(model)
defimpl String.Chars, for: Point.Transaction, do: def to_string(model), do: Point.Model.to_string(model)
