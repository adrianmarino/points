defimpl String.Chars, for: Point.Currency, do: def to_string(model), do: Point.Model.to_string(model)
defimpl String.Chars, for: Point.Entity, do: def to_string(model), do: Point.Model.to_string(model)
defimpl String.Chars, for: Point.User, do: def to_string(model), do: Point.Model.to_string(model)
defimpl String.Chars, for: Point.Movement, do: def to_string(model), do: Point.Model.to_string(model)
defimpl String.Chars, for: Point.Account, do: def to_string(model), do: Point.Model.to_string(model)
defimpl String.Chars, for: Point.ExchangeRate, do: def to_string(model), do: Point.Model.to_string(model)

defimpl String.Chars, for: Decimal, do: def to_string(value), do: Decimal.to_string(Decimal.round(value, 2))
