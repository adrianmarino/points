defmodule Mix.Tasks.Points.Client.Currencies do
  use Mix.Task.Point.Client
  @shortdoc "Show currencies. Params: token"
  defrun fn(token) -> points(base_url, token) |> currencies end

  defmodule Show do
    use Mix.Task.Point.Client
    @shortdoc "Show a currency. Params: token code"
    defrun fn([token | [code | _]])-> points(base_url, token) |> currencies(show: code) end
  end
  defmodule Create do
    use Mix.Task.Point.Client
    @shortdoc "Create a currency. Params: token code name"
    defrun fn([token | params]) -> points(base_url, token) |> currencies(create: Currency.new(params)) end
  end
  defmodule Update do
    use Mix.Task.Point.Client
    @shortdoc "Update currency name. Params: token code name"
    defrun fn([token | params]) -> points(base_url, token) |> currencies(update: Currency.new(params)) end
  end
  defmodule Delete do
    use Mix.Task.Point.Client
    @shortdoc "Delete a currency. Params: token code"
    defrun fn([token | [code | _]]) -> points(base_url, token) |> currencies(delete: code) end
  end
end
