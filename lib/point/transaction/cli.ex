defmodule Point.Transaction.CLI do
  import Point.MapUtil, only: [keys_to_atom: 1]
  import Point.CodeUtil, only: [to_module: 1]
  import ModuleLoader, only: [load: 2]
  import PointLogger
  alias Point.Config

  def compile(name, source), do: loader |> load(name: name, source: source)

  def execute(name, params) when is_bitstring(name) or is_atom(name) do
    try do
      exec_source(to_string(name), params)
    catch
      error -> {:error, error}
    end
  end
  def execute(transaction, params) do
    try do
      loader |> load(name: transaction.name, source: transaction.source, last_update: transaction.updated_at)
      exec_source(transaction.name, params)
    catch
      error -> {:error, error}
    end
  end

  defp exec_source(name, params) do
    module_name = to_module(name)
    info "Exec #{module_name}.run(#{inspect(keys_to_atom(params))})"
    {result, _} = Code.eval_string("#{module_name}.run(params)", [params: keys_to_atom(params)], __ENV__)
    case result do
      {:ok, _} ->
        info "Result: #{inspect(result)}"
        result
      {:error, error} -> inspect(error)
      _ -> {:error, "A transaction must return a {:ok/:error, ...} tuple instead of #{inspect(result)}!"}
    end
  end

  defp loader, do: ModuleLoader.create(path: Config.get(:tmp_path))
end
