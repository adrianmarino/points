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
end
