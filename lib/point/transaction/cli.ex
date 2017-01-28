
defmodule Point.Transaction.CLI do
  import Macro, only: [camelize: 1]
  import Point.MapUtil, only: [keys_to_atom: 1]
  import Point.FileUtil, only: [mk_file_path: 3]
  import Point.CodeUtil, only: [write_and_require: 2, update_and_require: 3]
  import PointLogger
  alias Point.Config

  def compile(name, source) do
    path = build_source_path(name)
    write_and_require(path, source)
  end

  def execute(name, params) when is_atom(name), do: execute(to_string(name), params)
  def execute(name, params) when is_bitstring(name) do
    try do
      exec_source(name, params)
    catch
      error -> {:error, error}
    end
  end
  def execute(transaction, params) do
    try do
      path = build_source_path(transaction.name)
      update_and_require(path, transaction.source, transaction.updated_at)
      exec_source(transaction.name, params)
    catch
      error -> {:error, error}
    end
  end

  defp exec_source(name, params) do
    info "Exec #{camelize name}.run(#{keys_to_atom(params)})"
    {result, _} = Code.eval_string("#{camelize name}.run(params)", [params: keys_to_atom(params)], __ENV__)
    case result do
      {:ok, _} ->
        info "Result: #{inspect(result)}"
        result
      {:error, error} -> inspect(error)
      _ -> {:error, "A transaction must return a {:ok/:error, ...} tuple instead of #{inspect(result)}!"}
    end
  end

  defp build_source_path(filename), do: mk_file_path(Config.get(:tmp_path), filename, "exs")
end
