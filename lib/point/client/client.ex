defmodule Point.Client do
  import Point.HTTPotion
  import Point.Router.Helpers
  alias Point.{JSON, MapUtil, Endpoint}

  defstruct [:base_url, :token]
  #
  #
  #----------------------------------------------------------------------------
  # Constructors
  #----------------------------------------------------------------------------
  def points(base_url), do: points(base_url, nil)
  def points(base_url, token) do
    HTTPotion.start
    %Point.Client{base_url: base_url, token: token}
  end
  #
  #
  #----------------------------------------------------------------------------
  # Sessions
  #----------------------------------------------------------------------------
  def sessions(client, sign_in: %Point.Client.Dto.Session{email: email, password: password}) do
    sign_in_resp(
      request(
        method: :post,
        url: url(client, session_path(Endpoint, :sign_in)),
        body: %{email: email, password: password},
        headers: %{}
      ),
      client
    )
  end
  def sessions(client, :sign_out) do
    request(
      method: :delete,
      url: url(client, session_path(Endpoint, :sign_out)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  def sessions(client) do
    request(
      method: :get,
      url: url(client, session_path(Endpoint, :index)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  #
  #
  #----------------------------------------------------------------------------
  # Users
  #----------------------------------------------------------------------------
  def users(client) do
    request(
      method: :get,
      url: url(client, user_path(Endpoint, :index)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  def users(client, show: email) do
    request(
      method: :get,
      url: url(client, user_path(Endpoint, :show, email)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  def users(client, create: %Point.Client.Dto.User{} = user) do
    request(
      method: :post,
      url: url(client, user_path(Endpoint, :create)),
      body: user,
      headers: %{token: client.token}
    )
  end
  def users(client, update: %Point.Client.Dto.User{} = user) do
    request(
      method: :put,
      url: url(client, user_path(Endpoint, :update, user.email)),
      body: MapUtil.comp_map(user, [:email]),
      headers: %{token: client.token}
    )
  end
  def users(client, delete: email) do
    request(
      method: :delete,
      url: url(client, user_path(Endpoint, :delete, email)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  #
  #
  #----------------------------------------------------------------------------
  # Roles
  #----------------------------------------------------------------------------
  def roles(client) do
    request(
      method: :get,
      url: url(client, role_path(Endpoint, :index)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  #
  #
  #----------------------------------------------------------------------------
  # Currencies
  #----------------------------------------------------------------------------
  def currencies(client) do
    request(
      method: :get,
      url: url(client, currency_path(Endpoint, :index)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  def currencies(client, show: code) do
    request(
      method: :get,
      url: url(client, currency_path(Endpoint, :show, code)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  def currencies(client, create: %Point.Client.Dto.Currency{code: code, name: name}) do
    request(
      method: :post,
      url: url(client, currency_path(Endpoint, :create)),
      body: %{code: code, name: name},
      headers: %{token: client.token}
    )
  end
  def currencies(client, update: %Point.Client.Dto.Currency{code: code, name: name}) do
    request(
      method: :put,
      url: url(client, currency_path(Endpoint, :update, code)),
      body: %{name: name},
      headers: %{token: client.token}
    )
  end
  def currencies(client, delete: code,) do
    request(
      method: :delete,
      url: url(client, currency_path(Endpoint, :delete, code)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  #
  #
  #----------------------------------------------------------------------------
  # Exchange rates
  #----------------------------------------------------------------------------
  def exchange_rates(client) do
    request(
      method: :get,
      url: url(client, exchange_rate_path(Endpoint, :index)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  def exchange_rates(client, show: %Point.Client.Dto.ExchangeRateId{source: source, target: target}) do
    request(
    method: :get,
    url: url(client, exchange_rate_path(Endpoint, :show, source, target)),
    body: %{},
    headers: %{token: client.token}
    )
  end
  def exchange_rates(client, create: %Point.Client.Dto.ExchangeRate{} = exchange_rate) do
    request(
      method: :post,
      url: url(client, exchange_rate_path(Endpoint, :create)),
      body: exchange_rate,
      headers: %{token: client.token}
    )
  end
  def exchange_rates(client, update: %Point.Client.Dto.ExchangeRate{source: source, target: target, value: value}) do
    request(
      method: :put,
      url: url(client, exchange_rate_path(Endpoint, :update, source, target)),
      body: %{value: value},
      headers: %{token: client.token}
    )
  end
  def exchange_rates(client, delete: %Point.Client.Dto.ExchangeRateId{source: source, target: target}) do
    request(
      method: :delete,
      url: url(client, exchange_rate_path(Endpoint, :delete, source, target)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  #
  #
  #----------------------------------------------------------------------------
  # Accounts
  #----------------------------------------------------------------------------
  def accounts(client) do
    request(
      method: :get,
      url: url(client, account_path(Endpoint, :index)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  def accounts(client, show: %Point.Client.Dto.Account{owner_email: owner_email, currency_code: currency_code}) do
    request(
      method: :get,
      url: url(client, account_path(Endpoint, :show, owner_email, currency_code)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  def accounts(client, create: %Point.Client.Dto.Account{} = account) do
    request(
      method: :post,
      url: url(client, account_path(Endpoint, :create)),
      body: account,
      headers: %{token: client.token}
    )
  end
  def accounts(client, delete: %Point.Client.Dto.Account{owner_email: owner_email, currency_code: currency_code}) do
    request(
      method: :delete,
      url: url(client, account_path(Endpoint, :delete, owner_email, currency_code)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  #
  #
  #----------------------------------------------------------------------------
  # Movements
  #----------------------------------------------------------------------------
  def movements(client, search: %Point.Client.Dto.AccountMovement{
    owner_email: owner_email,
    currency_code: currency_code,
    after_timestamp: after_timestamp})
  do
    request(
      method: :get,
      url: url(
        client,
        movement_path(Endpoint, :search_by_account_after, owner_email, currency_code, after_timestamp)
      ),
      body: %{},
      headers: %{token: client.token}
      )
  end
  def movements(client, search: %Point.Client.Dto.Between{from: from, to: to}) do
    request(
      method: :get,
      url: url(client, movement_path(Endpoint, :search_between, from, to)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  #
  #
  #----------------------------------------------------------------------------
  # Transactions
  #----------------------------------------------------------------------------
  def transactions(client) do
    request(
      method: :get,
      url: url(client, transaction_path(Endpoint, :index)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  def transactions(client, show: name) do
    request(
      method: :get,
      url: url(client, transaction_path(Endpoint, :show, to_string name)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  def transactions(client, exec: name, params: params) do
    request(
      method: :post,
      url: url(client, transaction_path(Endpoint, :execute, to_string name)),
      body: JSON.to_struct(params),
      headers: %{token: client.token}
    )
  end
  def transactions(client, create: %Point.Client.Dto.Transaction{name: name, source: source}) do
    request(
      method: :post,
      url: url(client, transaction_path(Endpoint, :create, to_string name)),
      body: source,
      headers: %{"Content-Type" => "application/text", token: client.token}
    )
  end
  def transactions(client, update: %Point.Client.Dto.Transaction{name: name, source: source}) do
    request(
      method: :put,
      url: url(client, transaction_path(Endpoint, :update, to_string name)),
      body: source,
      headers: %{"Content-Type" => "application/text", token: client.token}
    )
  end
  def transactions(client, delete: name) do
    request(
      method: :delete,
      url: url(client, transaction_path(Endpoint, :delete, to_string name)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  #
  #
  #----------------------------------------------------------------------------
  # Entities
  #----------------------------------------------------------------------------
  def entities(client) do
    request(
      method: :get,
      url: url(client, entity_path(Endpoint, :index)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  def entities(client, show: entity_code) do
    request(
      method: :get,
      url: url(client, entity_path(Endpoint, :show, entity_code)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  def entities(client, create: %Point.Client.Dto.Entity{} = entity) do
    request(
      method: :post,
      url: url(client, entity_path(Endpoint, :create)),
      body: entity,
      headers: %{token: client.token}
    )
  end
  def entities(client, update: %Point.Client.Dto.Entity{} = entity) do
    request(
      method: :put,
      url: url(client, entity_path(Endpoint, :update, entity.code)),
      body: %{name: entity.name},
      headers: %{token: client.token}
    )
  end
  def entities(client, delete: entity_code) do
    request(
      method: :delete,
      url: url(client, entity_path(Endpoint, :delete, entity_code)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  #
  #
  #----------------------------------------------------------------------------
  # Partners
  #----------------------------------------------------------------------------
  def partners(client, entity_code: entity_code) do
    request(
    method: :get,
    url: url(client, entity_partner_path(Endpoint, :index, entity_code)),
    body: %{},
    headers: %{token: client.token}
    )
  end
  def partners(client, create: %Point.Client.Dto.Partner{entity_code: entity_code, code: code}) do
    request(
      method: :post,
      url: url(client, entity_partner_path(Endpoint, :create, entity_code)),
      body: %{code: code},
      headers: %{token: client.token}
    )
  end
  def partners(client, delete: %Point.Client.Dto.Partner{entity_code: entity_code, code: code}) do
    request(
      method: :delete,
      url: url(client, entity_partner_path(Endpoint, :delete, entity_code, code)),
      body: %{},
      headers: %{token: client.token}
    )
  end
  #
  #
  #----------------------------------------------------------------------------
  # Private
  #----------------------------------------------------------------------------
  defp sign_in_resp(%HTTPotion.Response{status_code: 401} = response, _), do: {:error, response}
  defp sign_in_resp(%HTTPotion.Response{status_code: 201, body: body} = response, client) do
    {:ok, response, %Point.Client{base_url: client.base_url, token: JSON.to_struct(body)["token"]}}
  end
  defp url(%Point.Client{base_url: base_url}, url), do: "#{base_url}#{url}"
end
