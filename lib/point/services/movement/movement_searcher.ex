defmodule Point.MovementSearcher do
  import Ecto.Query
  alias Point.{Repo, Movement}

  def search(for: account, after: time) do
    Repo.all(from m in Movement,
              where: m.inserted_at >= ^time and m.source_id == ^account.id or m.target_id == ^account.id)
  end

  def search(from: from, to: to) do
    Repo.all(from m in Movement, where: m.inserted_at >= ^from and m.inserted_at <= ^to)
  end
end
