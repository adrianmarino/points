defmodule Mix.Tasks.Cli.Entities do
  use Mix.Task.Point.Client
  @shortdoc "Show entities. Params: token"
  defrun fn([token | _]) -> points(base_url(), token) |> entities end

  defmodule Show do
    use Mix.Task.Point.Client
    @shortdoc "Show an entity. Params: token code"
    defrun fn([token | [code | _]])-> points(base_url(), token) |> entities(show: code) end
  end
  defmodule Create do
    use Mix.Task.Point.Client
    @shortdoc "Create an entity. Params: token code name"
    defrun fn([token | params]) -> points(base_url(), token) |> entities(create: Entity.new(params)) end
  end
  defmodule Update do
    use Mix.Task.Point.Client
    @shortdoc "Update entity name. Params: token code name"
    defrun fn([token | params]) -> points(base_url(), token) |> entities(update: Entity.new(params)) end
  end
  defmodule Delete do
    use Mix.Task.Point.Client
    @shortdoc "Delete an entity. Params: token code"
    defrun fn([token | [code | _]]) -> points(base_url(), token) |> entities(delete: code) end
  end

  defmodule Partners do
    use Mix.Task.Point.Client
    @shortdoc "Show entity partners. Params: token entity_code"
    defrun fn([token | [entity_code | _]]) -> points(base_url(), token) |> partners(entity_code: entity_code) end

    defmodule Create do
      use Mix.Task.Point.Client
      @shortdoc "Create an entity partner. Params: token partner_code entity_code "
      defrun fn([token | params]) -> points(base_url(), token) |> partners(create: Partner.new(params)) end
    end
    defmodule Delete do
      use Mix.Task.Point.Client
      @shortdoc "Delete an entity partner. Params: token partner_code entity_code"
      defrun fn([token | params]) -> points(base_url(), token) |> partners(delete: Partner.new(params)) end
    end
  end
end
