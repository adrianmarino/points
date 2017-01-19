defmodule Point.TimeUtil do
  use Timex
  def humanize(duration), do: duration |> Timex.format_duration(:humanized)
  def sec_humanized(value), do: humanize(Duration.from_seconds(value))
end
