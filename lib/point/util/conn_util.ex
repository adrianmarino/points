defmodule Point.Phoenix.ConnUtil do
  alias Point.{Repo, EntityService}

  def remote_ip(conn), do: conn.remote_ip |> Tuple.to_list |> Enum.join(".")

  def current_session(conn), do: conn.assigns[:current_session]
  def current_user(conn), do: Repo.assoc(current_session(conn), :user)
  def current_user_id(conn), do: current_user(conn).id
  def current_entity(conn) do
    user = current_user(conn)
    EntityService.by(issuer_email: user.email)
  end
  def current_entity_id(conn), do: current_entity(conn).id

  def put_issuer_id(conn, to: params) do
    Map.put(params, "issuer_id", current_user_id(conn))
  end
  def put_entity_id(conn, to: params) do
    user = current_user(conn)
    entity = EntityService.by(issuer_email: user.email)
    Map.put(params, "entity_id", entity.id)
  end
  def put_issuer_and_entity_id(conn, to: params) do
    params = put_issuer_id(conn, to: params)
    put_entity_id(conn, to: params)
  end

  defmacro unbind_current_user(conn) do
    quote bind_quoted: [conn: conn], do: assign(conn, :current_session, nil)
  end
end
