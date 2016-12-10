defmodule Point.Ecto.DateTimeUtil do
  def to_usec(datetime) do
    datetime
      |> Ecto.DateTime.to_erl
      |> :calendar.datetime_to_gregorian_seconds
      |> Kernel.-(62167219200)
      |> Kernel.*(1000000)
      |> Kernel.+(datetime.usec)
      |> div(1000)
  end
  def usec_from(utc_datetime), do: to_usec(Ecto.DateTime.utc) - to_usec(utc_datetime)
  def sec_from(utc_datetime), do: usec_from(utc_datetime) |> div(1000)

  def sec_left(utc_datetime, seconds) do
    case seconds - sec_from(utc_datetime) do
      left when left <= 0 -> 0
      left -> left
    end
  end
end
