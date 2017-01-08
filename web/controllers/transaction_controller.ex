defmodule Point.TransactionController do
  use Point.Web, :controller
  require Engine
  import Macro, only: [camelize: 1]
  import Point.JSON
  alias Point.{MapUtil, Model}

  def perform(conn, %{"name" => name}) do
    try do
      {{:ok, result}, _} = execute(name, conn.body_params)
      ok(conn, result)
    rescue
      e -> error(conn, e)
    end
  end

  defp execute(name, params) do
    Code.eval_string(
      """
      require Engine
      Engine.run(#{camelize name}, params)
      """,
      [params: MapUtil.keys_to_atom(params)],
      __ENV__
    )
  end

  defp ok(conn, result), do: send_resp(conn, :ok, Model.to_string(result))
  defp error(conn, error) do
    send_resp(conn, :internal_server_error, to_json(%{error: error.message}))
  end
end
