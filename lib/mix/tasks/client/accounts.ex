defmodule Mix.Tasks.Cli.Accounts do
  use Mix.Task.Point.Client
  @shortdoc "Show accounts. Params: token"
  defrun fn([token | _]) -> points(base_url(), token) |> accounts end

  defmodule Show do
    use Mix.Task.Point.Client
    @shortdoc "Show an account. Params: token owner_email currency_code"
    defrun fn([token | account]) -> points(base_url(), token) |> accounts(show: Account.create(account)) end
  end
  defmodule Create do
    use Mix.Task.Point.Client
    @shortdoc "Create an account. Params: token owner_email currency_code"
    defrun fn([token | account]) -> points(base_url(), token) |> accounts(create: Account.create(account)) end
  end
  defmodule Delete do
    use Mix.Task.Point.Client
    @shortdoc "Delete an account. Params: token owner_email currency_code"
    defrun fn([token | account]) -> points(base_url(), token) |> accounts(delete: Account.create(account)) end
  end
end
