defmodule Point.Config do
  def get(key), do: Application.get_env(:point, Point.Endpoint)[key]
end
