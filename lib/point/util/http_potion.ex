defmodule Point.HTTPotion do
  import Point.JSON, only: [to_pretty_json: 1, to_json: 1, to_map: 1]
  import Map, only: [to_list: 1]
  import String, only: [upcase: 1]
  import PointLogger

  defmacro request(method: method, url: url, body: body, headers: headers) do
    quote bind_quoted: [method: method, url: url, body: body, headers: headers] do
      info """
      Request
      Url: #{upcase(to_string method)} #{url}
      Headers: #{to_pretty_json(headers)}
      Body: #{to_pretty_json(body)}
      """
      response = HTTPotion.request(
        method,
        url,
        [body: to_json(body), headers: ["Content-Type": "application/json"] ++ to_list(headers)]
      )
      info """
      Response
      Url: #{upcase(to_string method)} #{url}
      Status: #{response.status_code}
      Body: #{to_pretty_json(to_map(response.body))}
      """
      response
    end
  end
end
