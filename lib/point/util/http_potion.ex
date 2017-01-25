defmodule Point.HTTPotion do
  import Point.JSON, only: [to_json: 1]
  import Map, only: [to_list: 1, merge: 2]
  import PointLogger
  alias Point.HTTPotion.Describe

  defmacro request(method: method, url: url, body: body, headers: headers) do
    quote bind_quoted: [method: method, url: url, body: body, headers: headers] do
      info Describe.request(method, url, body, headers)
      response = HTTPotion.request(
        method,
        url,
        [
          body: to_json(body),
          headers: to_list(merge(%{"Content-Type" => "application/json"}, headers))
        ]
      )
      info Describe.response(response)
      response
    end
  end
end

defmodule Point.HTTPotion.Describe do
  import Point.JSON, only: [to_pretty_json: 1, to_struct: 1]
  import String, only: [upcase: 1]

  def request(method, url, body, headers) do
    "Request - #{upcase(to_string method)} #{url}#{to_desc("\nHeaders", headers)}#{to_desc("\nBody", body)}"
  end
  def response(resp), do: "Response - Status: #{resp.status_code}#{to_desc(", Body", to_struct(resp.body))}"

  defp to_desc(desc, %{} = map) do
    case Map.keys(map) do
      [] -> ""
      _ -> "#{desc}: #{to_pretty_json(map)}"
    end
  end
  defp to_desc(_, :badarg), do: ""
  defp to_desc(desc, list) when length(list) > 0, do: "#{desc}: #{to_pretty_json(list)}"
  defp to_desc(_, []), do: ""
  defp to_desc(desc, value) when is_atom(value), do: "#{desc}: #{value}"
  defp to_desc(desc, value) when is_bitstring(value), do: "#{desc}: #{value}"
end
