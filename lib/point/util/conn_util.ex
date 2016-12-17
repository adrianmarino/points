defmodule Point.Phoenix.ConnUtil do
  alias Point.Repo

  def remote_ip(conn), do: conn.remote_ip |> Tuple.to_list |> Enum.join(".")
  def current_session(conn), do: conn.assigns[:current_session]
  def current_user(conn), do: Repo.assoc(current_session(conn), :user)

  defmacro close_session(conn) do
    quote do: assign(unquote(conn), :current_session, nil)
  end
end
