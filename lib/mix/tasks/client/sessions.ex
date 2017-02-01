defmodule Mix.Tasks.Points.Client.Sessions do
  use Mix.Task.Point.Client
  @shortdoc "Show sessions"
  defrun fn(token)-> points(base_url, token) |> sessions end

  defmodule SignIn do
    use Mix.Task.Point.Client
    @shortdoc "Open a session"
    defrun fn(params)-> points(base_url) |> sessions(sign_in: Session.new(params)) end
  end
  defmodule SignOut do
    use Mix.Task.Point.Client
    @shortdoc "Close a session"
    defrun fn([token | _])-> points(base_url, token) |> sessions(:sign_out) end
  end
end
