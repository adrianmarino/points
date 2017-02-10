defmodule Mix.Tasks.Cli.ExchangeRates do
  use Mix.Task.Point.Client
  @shortdoc "Show exchange rates. Param: session_token"
  defrun fn(token) -> points(base_url, token) |> exchange_rates end

  defmodule Show do
    use Mix.Task.Point.Client
    @shortdoc "Show a exchange rate. Params: session_token source target"
    defrun fn([token | params]) -> points(base_url, token) |> exchange_rates(show: ExchangeRateId.new(params)) end
  end
  defmodule Create do
    use Mix.Task.Point.Client
    @shortdoc "Create a exchange rate. Params: session_token source target value (target = source * value)"
    defrun fn([token | params]) -> points(base_url, token) |> exchange_rates(create: ExchangeRate.new(params)) end
  end
  defmodule Update do
    use Mix.Task.Point.Client
    @shortdoc "Update a exchange rate. Params: session_token source target value"
    defrun fn([token | params]) -> points(base_url, token) |> exchange_rates(update: ExchangeRate.new(params)) end
  end
  defmodule Delete do
    use Mix.Task.Point.Client
    @shortdoc "Delete a exchange rate. Params: session_token source target"
    defrun fn([token | params]) -> points(base_url, token) |> exchange_rates(delete: ExchangeRateId.new(params)) end
  end
end
