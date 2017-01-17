defmodule Params do
  import PointLogger
  import Enum, only: [into: 2]
  import Map, only: [to_list: 1, get: 2]
  import Point.MapUtil, only: [map: 2]

  def valid_params(params, definition) when definition == %{}, do: params
  def valid_params(params, definition), do: _valid_params(params, definition, "")

  defp _valid_params(_, [], _), do: %{}
  defp _valid_params(params, definition, path) do
    into(map(to_list(definition), &(valid_param(&1, &2, get(params, &1), path))), %{})
  end

  defp valid_param(key, :required, nil, path), do: throw "#{path}#{key} param is required!"
  defp valid_param(key, :required, value, _), do: {key, value}
  defp valid_param(key, def_value, value, path) when is_map(def_value) do
    {key, _valid_params(value || %{}, def_value, "#{path}#{key}.")}
  end
  defp valid_param(key, def_value, nil, path) when def_value != nil do
    info "#{path}#{key} param doesn't found! Use \"#{def_value}\" default value."
    {key, def_value}
  end
end
