defmodule Mix.Tasks.Cli.Users do
  use Mix.Task.Point.Client
  @shortdoc "Show users"
  defrun fn(token)-> points(base_url, token) |> users end

  defmodule Show do
    use Mix.Task.Point.Client
    @shortdoc "Show a user. Params: token email"
    defrun fn([token | [email | _]])-> points(base_url, token) |> users(show: email) end
  end
  defmodule Create do
    use Mix.Task.Point.Client
    @shortdoc "Create a user. Params: token email password first_name last_name"
    defrun fn([token | params])-> points(base_url, token) |> users(create: User.new(params)) end
  end
  defmodule Update do
    use Mix.Task.Point.Client
    @shortdoc "Update a user. Params: token email password first_name last_name"
    defrun fn([token | params])-> points(base_url, token) |> users(update: User.new(params)) end
  end
  defmodule Delete do
    use Mix.Task.Point.Client
    @shortdoc "Delete a user. Params: token email"
    defrun fn([token | [email | _]])-> points(base_url, token) |> users(delete: email) end
  end
end
