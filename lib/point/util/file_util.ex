defmodule Point.FileUtil do
  def last_write(path) do
    case File.stat(path) do
      {:ok, stat} -> Timex.to_datetime(stat.atime)
      error -> error
    end
  end
end
