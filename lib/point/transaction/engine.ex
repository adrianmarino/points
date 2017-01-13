defmodule Engine do
  def run(program, params), do: Point.Repo.transaction(fn -> program.perform(params) end)
end
