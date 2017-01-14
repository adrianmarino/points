defmodule Point.FileUtil do
  def write_datetime(path) do
    case File.stat(path) do
      {:ok, stat} -> Timex.to_datetime(stat.atime)
      error -> error
    end
  end

  def was_writen(path, before_that: datetime, then: block) do
    case write_datetime(path) do
      {:ok, write_datetime} ->
        case Timex.compare(datetime, write_datetime) do
          result when result < 0 -> block.()
          _ -> true
        end
      _ -> block.()
    end
  end
end
