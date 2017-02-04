defmodule Point.CodeUtil do
  import Macro, only: [camelize: 1]
  import Logger

  def to_module(value) when is_bitstring(value) or is_atom(value), do: elem(Code.eval_string(camelize(to_string value)), 0)

  def ensure_loaded?(value), do: Code.ensure_loaded?(to_module(value))

  def unload(module) do
    module_name = to_module(module)
    # :code.delete(module_name)
    :code.purge(module_name)
  end

  def write_and_require(path, content) do
    try do
      File.write!(path, content)
      Code.require_file(path)
      info "Require #{path}"
      {:ok, path}
    rescue
      error ->
        File.rm(path)
        {:error, error}
    end
  end
end
