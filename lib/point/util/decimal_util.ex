defmodule Point.DecimalUtil do
  def inverse(value), do: Decimal.div(Decimal.new(1), Decimal.new(value))
  def to_string(value, round \\ 2), do: Decimal.to_string(Decimal.round(value, round))

  def compare(left, right) do
    Decimal.to_integer(Decimal.compare(Decimal.new(left), Decimal.new(right)))
  end
end
