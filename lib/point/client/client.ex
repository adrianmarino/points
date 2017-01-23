defmodule Point.Client do
  import Point.HTTPotion
  defstruct [:base_url]

  def points(base_url) do
    HTTPotion.start
    %Point.Client{base_url: base_url}
  end

  def sign_in(client, email: email, password: password) do
    request(
      method: :post,
      url: url(client, "sign_in"),
      body: %{email: email, password: password},
      headers: %{}
    )
  end

  def sign_out(client, token: token) do
    request(
      method: :delete,
      url: url(client, "sign_out"),
      body: %{},
      headers: %{token: token}
    )
  end

  defp url(client, url), do: "#{client.base_url}/api/v1/#{url}"
end
