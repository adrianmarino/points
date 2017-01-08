defmodule Point.MapUtil do
  import Enum, only: [reduce: 3]
  import Map, only: [put: 3]
  import String, only: [to_atom: 1]

  def keys_to_atom(map) when is_map(map) do
    map |> reduce(%{}, fn ({key, val}, acc) -> put(acc, to_atom(key), keys_to_atom(val)) end)
  end
  def keys_to_atom(val), do: val
end
