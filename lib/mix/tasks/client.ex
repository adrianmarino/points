defmodule Mix.Tasks.Points.Client do
  defmodule Sessions.SignIn do
    use Mix.Task.PointClient
    @shortdoc "Open a session"
    defrun fn([email | [password | _]])-> points(base_url) |> sign_in(email: email, password: password) end
  end
  defmodule Sessions.SignOut do
    use Mix.Task.PointClient
    @shortdoc "Close a session"
    defrun fn([token | _])-> points(base_url, token) |> sign_out end
  end
  defmodule Sessions do
    use Mix.Task.PointClient
    @shortdoc "Show all sessions"
    defrun fn([token | _])-> points(base_url, token) |> sessions end
  end

  defmodule Users do
    use Mix.Task.PointClient
    @shortdoc "Show users"
    defrun fn([token | _])-> points(base_url, token) |> users end
  end
  defmodule Users.Create do
    use Mix.Task.PointClient
    @shortdoc "Create a user. Params: token email password first_name last_name"
    defrun fn([token | user])-> points(base_url, token) |> add_user(Point.Client.User.create(user)) end
  end
  defmodule Users.Update do
    use Mix.Task.PointClient
    @shortdoc "Update a user. Params: token email password first_name last_name"
    defrun fn([token | user])-> points(base_url, token) |> update_user(Point.Client.User.create(user)) end
  end
  defmodule Users.Delete do
    use Mix.Task.PointClient
    @shortdoc "Delete a user. Params: token email"
    defrun fn([token | [email | _]])-> points(base_url, token) |> delete_user(email: email) end
  end

  defmodule Currencies do
    use Mix.Task.PointClient
    @shortdoc "Show currencies. Params: token"
    defrun fn([token | _]) -> points(base_url, token) |> currencies end
  end
  defmodule Currencies.Create do
    use Mix.Task.PointClient
    @shortdoc "Create a currency. Params: token code name"
    defrun fn([token | [code | [name | _]]]) -> points(base_url, token) |> add_currency(code: code, name: name) end
  end
  defmodule Currencies.Update do
    use Mix.Task.PointClient
    @shortdoc "Update currency name. Params: token code name"
    defrun fn([token | [code | [name | _]]]) -> points(base_url, token) |> update_currency(code: code, name: name) end
  end
  defmodule Currencies.Delete do
    use Mix.Task.PointClient
    @shortdoc "Delete a currency. Params: token code"
    defrun fn([token | [code | _]]) -> points(base_url, token) |> delete_currency(code: code) end
  end

  defmodule ExchangeRates do
    use Mix.Task.PointClient
    @shortdoc "Show exchange rates. Params: token"
    defrun fn([token | _]) -> points(base_url, token) |> exchange_rates end
  end
  defmodule ExchangeRates.Create do
    use Mix.Task.PointClient
    @shortdoc "Create a exchange rate. Params: token source_code target_code value"
    alias Point.Client.ExchangeRate
    defrun fn([token | exchange_rate]) ->
      points(base_url, token) |> add_exchange_rate(ExchangeRate.create(exchange_rate))
    end
  end
  defmodule ExchangeRates.Update do
    use Mix.Task.PointClient
    @shortdoc "Update a exchange rate. Params: token source_code target_code value"
    alias Point.Client.ExchangeRate
    defrun fn([token | exchange_rate]) ->
      points(base_url, token) |> update_exchange_rate(ExchangeRate.create(exchange_rate))
    end
  end
  defmodule ExchangeRates.Delete do
    use Mix.Task.PointClient
    @shortdoc "Delete a exchange rate. Params: token code"
    defrun fn([token | [source_code | [target_code | _]]]) ->
      points(base_url, token) |> delete_exchange_rate(source_code: source_code, target_code: target_code)
    end
  end
end
