defmodule Point.JSON do
  def to_json(map) do
    {:ok, response_body } = Poison.encode(map)
    response_body
  end
end
