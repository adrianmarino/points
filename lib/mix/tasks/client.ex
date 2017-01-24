defmodule Mix.Tasks.Point.Client do
  defmodule Sessions.SignIn do
    use Mix.Task.PointClient
    @shortdoc "Open a session"
    defrun fn([email | password])-> points(base_url) |> sign_in(email: email, password: password) end
  end
  defmodule Sessions.SignOut do
    use Mix.Task.PointClient
    @shortdoc "Close a session"
    defrun fn([token | _])-> points(base_url, token) |> sign_out end
  end
  defmodule Sessions do
    use Mix.Task.PointClient
    @shortdoc "Show all sessions"
    defrun fn([token | _])-> points(base_url, token) |> sessions end
  end
  defmodule Users do
    use Mix.Task.PointClient
    @shortdoc "Show users"
    defrun fn([token | _])-> points(base_url, token) |> users end
  end
  defmodule Users.Add do
    use Mix.Task.PointClient
    @shortdoc "Add a user. Params: token email password first_name last_name"
    defrun fn([token | user])-> points(base_url, token) |> add_user(Point.Client.User.create(user)) end
  end
  defmodule Users.Update do
    use Mix.Task.PointClient
    @shortdoc "Update a user. Params: token email password first_name last_name"
    defrun fn([token | user])-> points(base_url, token) |> update_user(Point.Client.User.create(user)) end
  end
  defmodule Users.Delete do
    use Mix.Task.PointClient
    @shortdoc "Delete a user. Params: token email"
    defrun fn([token | [email | _]])-> points(base_url, token) |> delete_user(email: email) end
  end
end
