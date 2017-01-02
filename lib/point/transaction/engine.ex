defmodule Engine do
  alias Point.Repo

  defmacro run(program, params: params) do
    quote bind_quoted: [program: program, params: params], do: Repo.transaction(fn -> program.perform(params) end)
  end
end
