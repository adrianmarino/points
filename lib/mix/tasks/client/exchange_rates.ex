defmodule Mix.Tasks.Points.Client.ExchangeRates do
  use Mix.Task.Point.Client
  @shortdoc "Show exchange rates. Params: token"
  defrun fn([token | _]) -> points(base_url, token) |> exchange_rates end

  defmodule Show do
    use Mix.Task.Point.Client
    @shortdoc "Show a exchange rate. Params: token source target"
    defrun fn([token | [source | [target | _]]]) ->
      points(base_url, token) |> exchange_rates(:show, source: source, target: target)
    end
  end
  defmodule Create do
    use Mix.Task.Point.Client
    @shortdoc "Create a exchange rate. Params: token source target value"
    defrun fn([token | exchange_rate]) ->
      points(base_url, token) |> exchange_rates(:create, ExchangeRate.create(exchange_rate))
    end
  end
  defmodule Update do
    use Mix.Task.Point.Client
    @shortdoc "Update a exchange rate. Params: token source target value"
    defrun fn([token | exchange_rate]) ->
      points(base_url, token) |> exchange_rates(:update, ExchangeRate.create(exchange_rate))
    end
  end
  defmodule Delete do
    use Mix.Task.Point.Client
    @shortdoc "Delete a exchange rate. Params: token source target"
    defrun fn([token | [source | [target | _]]]) ->
      points(base_url, token) |> exchange_rates(:delete, source: source, target: target)
    end
  end
end
