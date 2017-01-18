defmodule Point.CodeUtil do
  import Point.FileUtil, only: [last_write: 1]

  def write_and_require(path, content) do
    try do
      File.write!(path, content)
      Code.require_file(path)
      {:ok, path}
    rescue
      error ->
        File.rm(path)
        {:error, error}
    end
  end

  def update_and_require(path, content, updated_at) do
    case last_write(path) do
      {:ok, last_write} ->
        with Timex.compare(updated_at, last_write) > 0,
          do: write_and_require(path, content)
      _ -> write_and_require(path, content)
    end
  end
end
