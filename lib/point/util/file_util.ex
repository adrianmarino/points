defmodule Point.FileUtil do
  def last_write(path) do
    case File.stat(path) do
      {:ok, stat} -> {:ok, Timex.to_datetime(stat.atime)}
      error -> error
    end
  end

  def mk_file_path(path, filename, ext \\ "") do
    File.mkdir_p(path)
    "#{path}/#{filename}.#{ext}"
  end
end
