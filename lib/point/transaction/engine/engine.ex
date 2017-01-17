defmodule Engine do
  import Point.Repo, only: [transaction: 1]
  def run(program, params), do: transaction fn -> program.run(params) end
end
