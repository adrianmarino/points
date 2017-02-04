defmodule Point.CodeUtil do
  import Macro, only: [camelize: 1]
  import Logger

  def to_module(value) when is_bitstring(value) or is_atom(value), do: elem(Code.eval_string(camelize(to_string value)), 0)

  def ensure_loaded?(value), do: Code.ensure_loaded?(to_module(value))

  def load_file(path) do
    Code.load_file(path)
    info "Load #{path}"
  end

  def write_and_load(path, content) do
    try do
      File.write!(path, content)
      load_file(path)
      {:ok, path}
    rescue
      error ->
        File.rm(path)
        {:error, error}
    end
  end
end
