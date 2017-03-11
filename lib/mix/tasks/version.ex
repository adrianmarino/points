defmodule Mix.Tasks.Point.Version do
  use Mix.Task

  def run(_) do
    IO.puts(Point.Mixfile.project[:version])
  end
end
