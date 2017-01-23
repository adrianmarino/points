defmodule Point.TimeUtil do
  use Timex
  def humanize(duration), do: duration |> Timex.format_duration(:humanized)
  def sec_humanized(value), do: humanize(Duration.from_seconds(value))
  def is(left, greater_that:  right), do: Timex.compare(left, right) > 0
end
