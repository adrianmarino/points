defmodule Point.MapUtil do
  import Enum, only: [reduce: 3]
  import Map, only: [to_list: 1, put: 3]
  import String, only: [to_atom: 1]

  def keys_to_atom(map) when is_map(map) do
    map |> reduce(%{}, fn ({key, val}, acc) -> put(acc, to_atom(key), keys_to_atom(val)) end)
  end
  def keys_to_atom(val), do: val

  def map(hash, block), do: Enum.map(to_list(hash), &(block.(elem(&1, 0), elem(&1, 1))))
  def sub_map(hash, keys), do: elem(Map.split(hash, keys), 0)
  def comp_map(hash, keys), do: elem(Map.split(hash, keys), 1)
end
