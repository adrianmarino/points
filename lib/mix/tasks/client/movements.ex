defmodule Mix.Tasks.Cli.Movements do
  defmodule ByAccountAfter do
    use Mix.Task.Point.Client
    @shortdoc "Show account movements after a date. Params: token owner_email currency_code timestamp (after format: YYYYMMDD_HHMM)"
    defrun fn([token | params]) -> points(base_url, token) |> movements(search: AccountMovement.create(params)) end
  end
  defmodule Between do
    use Mix.Task.Point.Client
    @shortdoc "Show movements between dates. Params: from to (format: YYYYMMDD_HHMM)"
    defrun fn([token | params]) -> points(base_url, token) |> movements(search: Between.create(params)) end
  end
end
