defmodule Point.StringUtil do
  def to_atom(value) when is_atom(value), do: value
  def to_atom(value), do: String.to_atom(value)
end
