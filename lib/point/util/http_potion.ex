defmodule Point.HTTPotion do
  import Point.JSON, only: [to_json: 1]
  import Map, only: [to_list: 1]
  import PointLogger

  defmacro request(method: method, url: url, body: body, headers: headers) do
    quote bind_quoted: [method: method, url: url, body: body, headers: headers] do
      info "Request - Url: #{method} #{url}, Headers: #{headers}, Body: #{body}"
      response = HTTPotion.request(
        method,
        url,
        [body: to_json(body), headers: ["Content-Type": "application/json"] ++ to_list(headers)]
      )
      info "Response(#{response.status_code}) #{response.body}"
      response
    end
  end
end
