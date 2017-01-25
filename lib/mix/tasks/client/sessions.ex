defmodule Mix.Tasks.Points.Client.Sessions do
  use Mix.Task.Point.Client
  @shortdoc "Show all sessions"
  defrun fn([token | _])-> points(base_url, token) |> sessions end

  defmodule SignIn do
    use Mix.Task.Point.Client
    @shortdoc "Open a session"
    defrun fn([email | [password | _]])-> points(base_url) |> sign_in(email: email, password: password) end
  end
  defmodule SignOut do
    use Mix.Task.Point.Client
    @shortdoc "Close a session"
    defrun fn([token | _])-> points(base_url, token) |> sign_out end
  end
end
