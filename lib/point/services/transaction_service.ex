defmodule Point.TransactionService do
  import Macro, only: [camelize: 1]
  alias Point.MapUtil

  def execute(name, params) do
    try do
      {result, _} = Code.eval_string(
        """
        require Engine
        Engine.run(#{camelize name}, params)
        """,
        [params: MapUtil.keys_to_atom(params)],
        __ENV__
      )
      result
    rescue
      e -> {:error, e}
    end
  end

  def insert(name, src) do
    case Code.string_to_quoted(src) do
      {:error, message} -> {:error, elem(message, 1)}
      {:ok, compiled_src} ->
        {:ok, compiled_src}
    end
  end
end
