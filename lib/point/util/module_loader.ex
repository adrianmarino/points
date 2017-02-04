defmodule ModuleLoader do
  import Point.FileUtil, only: [mk_file_path: 3, last_write: 1]
  import Point.CodeUtil, only: [load_file:  1, write_and_load: 2, ensure_loaded?: 1]
  import Logger
  alias Point.TimeUtil

  defstruct [:path]

  def create(path: path), do: %ModuleLoader{path: path}

  def load(loader, name: name, source: source) do
    load(loader, name: name, source: source, last_update: Timex.now)
  end
  def load(loader, name: name, source: source, last_update: last_update) do
    module_path = module_path(loader, name)

    case last_write(module_path) do
      {:ok, last_write} -> # When found a module file...
        cond do
          TimeUtil.is(last_update, greater_or_equal_that: last_write) -> # But outdated...
            write_and_load(module_path, source)
            info "#{module_path} Updated and loaded!"
          ensure_loaded?(name) ->  # And is already updated...
            info "#{module_path} Already updated and loaded!."
          true -> # But is unloaded...
            info "#{module_path} Already updated but not unloaded!."
            load_file(module_path)
            info "#{module_path} loaded!"
        end
      {:error, err} -> # when not found a module file...
        warn("Require file. Error: #{inspect err}")
        write_and_load(module_path, source)
    end
    build_ok(module_path, name, source)
  end

  defp module_path(loader, filename), do: mk_file_path(loader.path, filename, "exs")

  defp build_ok(module_path, name, source), do: {:ok, %{module_path: module_path, name: name, source: source}}
end
