defmodule Mix.Tasks.Points.Client.ExchangeRates do
  use Mix.Task.Point.Client
  @shortdoc "Show exchange rates. Params: token"
  defrun fn([token | _]) -> points(base_url, token) |> exchange_rates end

  defmodule Show do
    use Mix.Task.Point.Client
    @shortdoc "Show a exchange rate. Params: token source target"
    defrun fn([token | [source | [target | _]]]) ->
      points(base_url, token) |> show_exchange_rate(source: source, target: target)
    end
  end
  defmodule Create do
    use Mix.Task.Point.Client
    @shortdoc "Create a exchange rate. Params: token source target value"
    alias Point.Client.ExchangeRate
    defrun fn([token | exchange_rate]) ->
      points(base_url, token) |> add_exchange_rate(ExchangeRate.create(exchange_rate))
    end
  end
  defmodule Update do
    use Mix.Task.Point.Client
    @shortdoc "Update a exchange rate. Params: token source target value"
    alias Point.Client.ExchangeRate
    defrun fn([token | exchange_rate]) ->
      points(base_url, token) |> update_exchange_rate(ExchangeRate.create(exchange_rate))
    end
  end
  defmodule Delete do
    use Mix.Task.Point.Client
    @shortdoc "Delete a exchange rate. Params: token source target"
    defrun fn([token | [source | [target | _]]]) ->
      points(base_url, token) |> delete_exchange_rate(source: source, target: target)
    end
  end
end
