defmodule Mix.Tasks.Points.Client.Currencies do
  use Mix.Task.Point.Client
  @shortdoc "Show currencies. Params: token"
  defrun fn([token | _]) -> points(base_url, token) |> currencies end

  defmodule Show do
    use Mix.Task.Point.Client
    @shortdoc "Show a currency. Params: token code"
    defrun fn([token | [code | _]])-> points(base_url, token) |> show_currency(code: code) end
  end
  defmodule Create do
    use Mix.Task.Point.Client
    @shortdoc "Create a currency. Params: token code name"
    defrun fn([token | [code | [name | _]]]) -> points(base_url, token) |> add_currency(code: code, name: name) end
  end
  defmodule Update do
    use Mix.Task.Point.Client
    @shortdoc "Update currency name. Params: token code name"
    defrun fn([token | [code | [name | _]]]) -> points(base_url, token) |> update_currency(code: code, name: name) end
  end
  defmodule Delete do
    use Mix.Task.Point.Client
    @shortdoc "Delete a currency. Params: token code"
    defrun fn([token | [code | _]]) -> points(base_url, token) |> delete_currency(code: code) end
  end
end
