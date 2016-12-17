defmodule Point.DecimalUtil do
  def zero, do: Decimal.new(0)

  def inverse(value), do: Decimal.div(Decimal.new(1), Decimal.new(value))
  def to_string(value, round \\ 2), do: Decimal.to_string(Decimal.round(value, round))

  def is(left, greater_that: right), do: compare(left, right) > 0
  def is(left, less_that: right), do: compare(left, right) < 0
  def is(left, greater_or_that: right), do: compare(left, right) >= 0
  def is(left, less_or_that: right), do: compare(left, right) <= 0

  def compare(left, right), do: Decimal.to_integer(Decimal.compare(Decimal.new(left), Decimal.new(right)))
end
