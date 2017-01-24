defmodule Mix.Tasks.Point do
  defmodule SignIn do
    use Mix.Task.PointClient
    @shortdoc "Open a session"
    defrun fn(params)-> points(base_url) |> sign_in(email: first(params), password: last(params)) end
  end
  defmodule SignOut do
    use Mix.Task.PointClient
    @shortdoc "Close a session"
    defrun fn(params)-> points(base_url, first(params)) |> sign_out end
  end
  defmodule Sessions do
    use Mix.Task.PointClient
    @shortdoc "Show opened sessions"
    defrun fn(params)-> points(base_url, first(params)) |> sessions end
  end
end
