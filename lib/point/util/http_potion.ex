defmodule Point.HTTPotion do
  import Point.MapUtil, only: [to_keyword_list: 1]
  alias Point.HTTPotion.{Logger, RequestBuilder}

  defmacro request(method: method, url: url, body: body, headers: headers) do
    quote bind_quoted: [method: method, url: url, body: body, headers: headers] do
      headers = RequestBuilder.default_headers(headers)
      Logger.request(method, url, body, headers)

      body = RequestBuilder.format_body(body, headers["Content-Type"])

      response = HTTPotion.request(method, url, [body: body, headers: to_keyword_list(headers)])
      Logger.response(response)
      response
    end
  end
end

defmodule Point.HTTPotion.RequestBuilder do
  import Point.JSON, only: [to_json: 1]

  def default_headers(headers) do
    Map.merge(%{"Content-Type" => "application/json"}, headers)
  end
  def format_body(body, "application/json"), do: to_json(body)
  def format_body(body, "application/text"), do: body
end

defmodule Point.HTTPotion.Logger do
  import Point.JSON, only: [to_pretty_json: 1, to_struct: 1]
  import String, only: [upcase: 1]
  import PointLogger

  def request(method, url, body, headers) do
    info "Request - #{upcase(to_string method)} #{url}#{to_desc("\nHeaders", headers)}#{to_desc("\nBody", body)}"
  end

  def response(%HTTPotion.ErrorResponse{message: message}), do: error "Response - Error: #{message}"
  def response(%HTTPotion.Response{status_code: status_code, body: body}) do
    info "Response - Status: #{status_code}#{to_desc(", Body", to_result(body))}"
  end

  defp to_result(body) do
    case to_struct(body) do
      nil -> "Empty"
      [] -> "Empty"
      "" -> "Empty"
      result -> result
    end
  end

  defp to_desc(desc, %{} = map) do
    case Map.keys(map) do
      [] -> ""
      _ -> "#{desc}: #{to_pretty_json(map)}"
    end
  end

  defp to_desc(desc, value) when is_bitstring(value), do: "#{desc}: #{value}"

  defp to_desc(_, :badarg), do: ""
  defp to_desc(desc, value) when is_atom(value), do: "#{desc}: #{value}"

  defp to_desc(desc, list) when length(list) > 0, do: "#{desc}: #{to_pretty_json(list)}"
  defp to_desc(_, list) when length(list) == 0, do: ""
end
