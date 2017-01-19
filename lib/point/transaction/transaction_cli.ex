
defmodule Point.TransactionCli do
  import Macro, only: [camelize: 1]
  import Point.MapUtil, only: [keys_to_atom: 1]
  import Point.FileUtil, only: [mk_file_path: 3]
  import Point.CodeUtil, only: [write_and_require: 2, update_and_require: 3]
  alias Point.Config

  def compile(name, source) do
    path = build_source_path(name)
    write_and_require(path, source)
  end

  def execute(transaction, params) do
    try do
      path = build_source_path(transaction.name)
      update_and_require(path, transaction.source, transaction.updated_at)
      exec_source(transaction, params)
    catch
      error -> {:error, error}
    end
  end

  defp exec_source(transaction, params) do
    {result, _} = Code.eval_string("#{camelize transaction.name}.run(params)", [params: keys_to_atom(params)], __ENV__)
    result
  end

  defp build_source_path(filename), do: mk_file_path(Config.get(:tmp_path), filename, "exs")
end
