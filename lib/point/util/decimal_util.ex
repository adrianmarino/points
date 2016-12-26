defmodule Point.DecimalUtil do
  def zero, do: Decimal.new(0)

  def is_decimal(%Decimal{}), do: true

  def inverse(value), do: Decimal.div(Decimal.new(1), Decimal.new(value))

  def is(left, greater_that: right), do: compare(left, right) > 0
  def is(left, less_that: right), do: compare(left, right) < 0
  def is(left, greater_or_that: right), do: compare(left, right) >= 0
  def is(left, less_or_that: right), do: compare(left, right) <= 0

  def compare(left, right), do: Decimal.to_integer(Decimal.compare(Decimal.new(left), Decimal.new(right)))
end

defimpl String.Chars, for: Decimal do
  def to_string(value), do: Decimal.to_string(Decimal.round(value, 2))
end
