defmodule Point.TransactionRunner do
  import Macro, only: [camelize: 1]
  import Point.FileUtil, only: [last_write: 1]
  import Point.MapUtil, only: [keys_to_atom: 1]
  import Logger
  alias Point.Config

  def execute(transaction, params) do
    try do
      require_source(transaction)
      exec_source(transaction, params)
    rescue
      error -> {:error, error}
    end
  end

  defp exec_source(transaction, params) do
    {result, _} = Code.eval_string(
      "Engine.run(#{camelize transaction.name}, params)",
      [params: keys_to_atom(params)],
      __ENV__
    )
    info "Engine.run(#{camelize transaction.name}, #{keys_to_atom(params)}) was executed!"
    result
  end

  defp require_source(transaction) do
    File.mkdir(tmp_path)
    path = "#{tmp_path}/#{transaction.name}.exs"

    case last_write(path) do
      {:ok, last_write} ->
        if Timex.compare(transaction.updated_at, last_write) > 0,
          do: write_and_require(path, transaction.source); info "#{path} script was updated and required!"
      _ ->  write_and_require(path, transaction.source); info "#{path} script was created and required!"
    end
  end

  defp write_and_require(path, content) do
    File.write!(path, content)
    Code.require_file(path)
  end

  defp tmp_path, do: Config.get(:tmp_path)
end
