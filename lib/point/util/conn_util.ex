defmodule Point.Phoenix.ConnUtil do
  def remote_ip(conn), do: conn.remote_ip |> Tuple.to_list |> Enum.join(".")
end
