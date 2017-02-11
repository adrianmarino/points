defmodule Point.MovementSearcher do
  import Ecto.Query
  alias Point.{Repo, Movement}

  def before(time: time), do: Repo.all(from m in Movement, where: m.inserted_at >= ^time)
end
