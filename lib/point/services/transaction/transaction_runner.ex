defmodule Point.TransactionRunner do
  import Macro, only: [camelize: 1]
  require Logger
  alias Point.{Config, MapUtil, FileUtil}

  def execute(transaction, params) do
    try do
      path = script_path(transaction.name)

      FileUtil.was_writen(path, before_that: transaction.updated_at, then: fn ->
        File.write!(path, transaction.source)
        Logger.info "#{path} script was updated!"
      end)

      Logger.info "Require: #{path}"
      Code.require_file(path)

      exec(transaction, params)
    rescue
      e -> {:error, e}
    end
  end

  defp exec(transaction, params) do
    exec_src = "Engine.run(#{camelize transaction.name}, params)"
    Logger.info "Execute: #{exec_src}"
    {result, _} = Code.eval_string(exec_src, [params: MapUtil.keys_to_atom(params)], __ENV__)
    result
  end

  defp script_path(filename) do
    File.mkdir(Config.get(:tmp_path))
    "#{Config.get(:tmp_path)}/#{filename}.exs"
  end
end
