defmodule ModuleLoader do
  import Point.FileUtil, only: [mk_file_path: 3, last_write: 1]
  import Point.CodeUtil, only: [write_and_require: 2, unload: 1, to_module: 1, ensure_loaded?: 1]
  import Logger
  alias Point.TimeUtil

  defstruct [:base_path]

  def create(base_path: base_path), do: %ModuleLoader{base_path: base_path}

  def load(loader, name: name, content: content), do: reload(loader, name: name, content: content, last_update: Timex.zero)

  def reload(loader, name: name, content: content, last_update: last_update) do
    module_path = module_path(loader, name)

    case last_write(module_path) do
      {:ok, last_write} -> # There is a modulenil File...
        cond do
          TimeUtil.is(last_update, greater_or_equal_that: last_write) -> # But outdated...
            unload(name)
            info "#{to_module name} unloaded!"
            write_and_require(module_path, content)
            info "#{module_path} required!"
          ensure_loaded?(name) ->  # And already updated...
            info "#{module_path} Already updated and required!."
          true ->
            info "#{module_path} Already updated!."
            Code.require_file(module_path)
            info "#{module_path} required!"
        end
      {:error, err} -> # File not exist
        warn("Require file. Error: #{inspect err}")
        write_and_require(module_path, content)
    end
    build_ok(module_path, name, content)
  end

  defp module_path(loader, filename), do: mk_file_path(loader.base_path, filename, "exs")

  defp build_ok(module_path, name, content), do: {:ok, %{module_path: module_path, name: name, content: content}}
end
