defmodule Mix.Tasks.Cli.Sessions do
  use Mix.Task.Point.Client
  @shortdoc "Show sessions. Param: session_token"
  defrun fn(token)-> points(base_url, token) |> sessions end

  defmodule SignIn do
    use Mix.Task.Point.Client
    @shortdoc "Open a session. Params: username password"
    defrun fn(params)-> points(base_url) |> sessions(sign_in: Session.new(params)) end
  end
  defmodule SignOut do
    use Mix.Task.Point.Client
    @shortdoc "Close a session. Param: session_token"
    defrun fn([token | _])-> points(base_url, token) |> sessions(:sign_out) end
  end
end
