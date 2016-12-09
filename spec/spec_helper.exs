Code.require_file("spec/phoenix_helper.exs")
Code.require_file("spec/point/helper/service_spec_helper.exs")
Code.require_file("spec/point/helper/connection_helper.exs")

ESpec.configure fn(config) ->
  config.before fn(_tags) ->
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Point.Repo)
  end

  config.finally fn(_shared) ->
    Ecto.Adapters.SQL.Sandbox.checkin(Point.Repo, [])
  end
end

{:ok, _} = Application.ensure_all_started(:ex_machina)
