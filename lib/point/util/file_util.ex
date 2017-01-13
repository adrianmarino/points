defmodule Point.FileUtil do
  def write_datetime(path) do
    case File.stat(path) do
      {:ok, stat} -> Timex.to_datetime(stat.atime)
      error -> error
    end
  end

  def was_writed(path, before_that: datetime) do
    case write_datetime(path) do
      {:ok, write_datetime} -> Timex.compare(datetime, write_datetime) < 0
      _ -> true
    end
  end
end
