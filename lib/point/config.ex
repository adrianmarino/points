defmodule Point.Config do
  def get(key), do: point()[key]

  def base_url, do: "#{point()[:url][:host]}:#{point()[:http][:port]}"

  defp point, do: Application.get_env(:point, Point.Endpoint)
end
