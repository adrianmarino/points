defmodule PointClient do
  defmacro __using__(_options) do
    quote do
      use Mix.Task
      import List
      import Point.Client
      import Point.Config
    end
  end
end

defmodule Mix.Tasks.Point do
  defmodule SignIn do
    use PointClient
    @shortdoc "Open a session"
    def run(params), do: points(base_url) |> sign_in(email: List.first(params), password: List.last(params))
  end
  defmodule SignOut do
    use PointClient
    @shortdoc "Close a session"
    def run(params), do: points(base_url) |> sign_out(token: first(params))
  end
  defmodule Sessions do
    use PointClient
    @shortdoc "Show opened sessions"
    def run(params), do: points(base_url) |> sessions(token: first(params))
  end
end
