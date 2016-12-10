defmodule Point.TimeUtil do
  def sec_humanized(secs) when secs > 0, do: Timex.Duration.from_seconds(secs) |> Timex.format_duration(:humanized)
  def sec_humanized(secs), do: "0 seconds"
end
