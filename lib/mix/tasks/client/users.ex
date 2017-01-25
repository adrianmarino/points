defmodule Mix.Tasks.Points.Client.Users do
  use Mix.Task.Point.Client
  @shortdoc "Show users"
  defrun fn([token | _])-> points(base_url, token) |> users end

  defmodule Show do
    use Mix.Task.Point.Client
    @shortdoc "Show a user. Params: token email"
    defrun fn([token | [email | _]])-> points(base_url, token) |> show_user(email: email) end
  end
  defmodule Create do
    use Mix.Task.Point.Client
    @shortdoc "Create a user. Params: token email password first_name last_name"
    defrun fn([token | user])-> points(base_url, token) |> add_user(Point.Client.User.create(user)) end
  end
  defmodule Update do
    use Mix.Task.Point.Client
    @shortdoc "Update a user. Params: token email password first_name last_name"
    defrun fn([token | user])-> points(base_url, token) |> update_user(Point.Client.User.create(user)) end
  end
  defmodule Delete do
    use Mix.Task.Point.Client
    @shortdoc "Delete a user. Params: token email"
    defrun fn([token | [email | _]])-> points(base_url, token) |> delete_user(email: email) end
  end
end
