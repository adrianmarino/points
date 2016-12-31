defmodule Point.Phoenix.ConnUtil do
  alias Point.Repo

  def remote_ip(conn), do: conn.remote_ip |> Tuple.to_list |> Enum.join(".")
  def current_session(conn), do: conn.assigns[:current_session]
  def current_user(conn), do: Repo.assoc(current_session(conn), :user)
  def currency_user_id(conn), do: current_user(conn).id
  def put_issuer_id(conn, to: params), do: Map.put(params, "issuer_id", currency_user_id(conn))

  defmacro unbind_current_user(conn) do
    quote bind_quoted: [conn: conn], do: assign(conn, :current_session, nil)
  end
end
