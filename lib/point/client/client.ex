defmodule Point.Client do
  import Point.HTTPotion
  alias Point.JSON
  alias Point.MapUtil

  defstruct [:base_url, :token]

  def points(base_url), do: points(base_url, nil)
  def points(base_url, token) do
    HTTPotion.start
    %Point.Client{base_url: base_url, token: token}
  end

  def sign_in(client, email: email, password: password) do
    sign_in_resp(
      request(method: :post, url: url(client, "sign_in"), body: %{email: email, password: password}, headers: %{}),
      client
    )
  end

  def sign_out(client) do
    request(method: :delete, url: url(client, "sign_out"), body: %{}, headers: %{token: client.token})
  end

  def sessions(client) do
    request(method: :get, url: url(client, "sessions"), body: %{}, headers: %{token: client.token})
  end

  def add_user(client, %Point.Client.User{} = user) do
    request(method: :post, url: url(client, "users"), body: user, headers: %{token: client.token})
  end

  def update_user(client, %Point.Client.User{} = user) do
    request(
      method: :put,
      url: url(client, "users/#{user.email}"),
      body: MapUtil.comp_map(user, [:email]),
      headers: %{token: client.token}
    )
  end

  def show_user(client, email: email) do
    request(method: :get, url: url(client, "users/#{email}"), body: %{}, headers: %{token: client.token})
  end

  def delete_user(client, email: email) do
    request(method: :delete, url: url(client, "users/#{email}"), body: %{}, headers: %{token: client.token})
  end

  def users(client), do: request(method: :get, url: url(client, "users"), body: %{}, headers: %{token: client.token})

  def add_currency(client, code: code, name: name) do
    request(
      method: :post,
      url: url(client, "currencies"),
      body: %{code: code, name: name},
      headers: %{token: client.token}
    )
  end

  def update_currency(client, code: code, name: name) do
    request(method: :put, url: url(client, "currencies/#{code}"), body: %{name: name}, headers: %{token: client.token})
  end

  def delete_currency(client, code: code) do
    request(method: :delete, url: url(client, "currencies/#{code}"), body: %{}, headers: %{token: client.token})
  end

  def currencies(client) do
    request(method: :get, url: url(client, "currencies"), body: %{}, headers: %{token: client.token})
  end

  def add_exchange_rate(client, %Point.Client.ExchangeRate{} = exchange_rate) do
    request(
      method: :post,
      url: url(client, "exchange_rates"),
      body: exchange_rate,
      headers: %{token: client.token}
    )
  end

  def update_exchange_rate(client, %Point.Client.ExchangeRate{} = exchange_rate) do
    request(
      method: :put,
      url: url(client, "exchange_rates/#{exchange_rate.source}/#{exchange_rate.target}"),
      body: %{value: exchange_rate.value},
      headers: %{token: client.token}
    )
  end

  def delete_exchange_rate(client, source: source, target: target) do
    request(
      method: :delete,
      url: url(client, "exchange_rates/#{source}/#{target}"),
      body: %{},
      headers: %{token: client.token}
    )
  end

  def exchange_rates(client) do
    request(method: :get, url: url(client, "exchange_rates"), body: %{}, headers: %{token: client.token})
  end

  def add_account(client, %Point.Client.Account{} = account) do
    request(method: :post, url: url(client, "accounts"), body: account, headers: %{token: client.token})
  end

  def delete_account(client, %Point.Client.Account{} = account) do
    request(
      method: :delete,
      url: url(client, "accounts/#{account.owner_email}/#{account.currency_code}"),
      body: account,
      headers: %{token: client.token}
    )
  end

  def accounts(client) do
    request(method: :get, url: url(client, "accounts"), body: %{}, headers: %{token: client.token})
  end

  def transactions(client) do
    request(method: :get, url: url(client, "transactions"), body: %{}, headers: %{token: client.token})
  end

  def add_transaction(client, %Point.Client.Transaction{} = transaction) do
    request(
      method: :post,
      url: url(client, "transactions/#{transaction.name}"),
      body: transaction.source,
      headers: %{"Content-Type" => "application/text", token: client.token}
    )
  end

  def update_transaction(client, %Point.Client.Transaction{} = transaction) do
    request(
      method: :put,
      url: url(client, "transactions/#{transaction.name}"),
      body: %{source: transaction.source},
      headers: %{"Content-Type" => "application/text", token: client.token}
    )
  end

  def delete_transaction(client, name: name) do
    request(method: :delete, url: url(client, "transactions/#{name}"), body: %{}, headers: %{token: client.token})
  end

  def show_transaction(client, name: name) do
    request(method: :get, url: url(client, "transactions/#{name}"), body: %{}, headers: %{token: client.token})
  end

  defp sign_in_resp(%HTTPotion.Response{status_code: 401} = response, _), do: {:error, response}
  defp sign_in_resp(%HTTPotion.Response{status_code: 201, body: body} = response, client) do
    {:ok, response, %Point.Client{base_url: client.base_url, token: JSON.to_struct(body)["token"]}}
  end
  defp url(client, url), do: "#{client.base_url}/api/v1/#{url}"
end
