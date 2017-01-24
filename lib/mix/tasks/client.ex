defmodule Mix.Tasks.Point.Client do
  defmodule Sessions.SignIn do
    use Mix.Task.PointClient
    @shortdoc "Open a session"
    defrun fn(params)-> points(base_url) |> sign_in(email: first(params), password: last(params)) end
  end
  defmodule Sessions.SignOut do
    use Mix.Task.PointClient
    @shortdoc "Close a session"
    defrun fn(params)-> points(base_url, first(params)) |> sign_out end
  end
  defmodule Sessions.All do
    use Mix.Task.PointClient
    @shortdoc "Show all sessions"
    defrun fn(params)-> points(base_url, first(params)) |> sessions end
  end
end
