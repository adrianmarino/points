defmodule Point.StopWatch do
  use Timex
  defstruct [:begin]

  def begin, do: %Point.StopWatch{begin: Duration.now}
  def elapsed_time(stop_watch), do: Duration.diff(Duration.now, stop_watch.begin)

  defimpl String.Chars do
    alias Point.{StopWatch, TimeUtil}
    def to_string(stop_watch), do: StopWatch.elapsed_time(stop_watch) |> TimeUtil.humanize
  end
end
