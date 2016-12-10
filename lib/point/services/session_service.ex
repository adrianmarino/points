defmodule Point.SessionService do
  import Ecto.Query
  import Point.Ecto.DateTimeUtil
  import Enum
  import Map, only: [put: 3]
  alias Point.{Repo, Session, User}

  def all() do
    Repo.all(
      from s in Session, join: u in User,
      where: s.user_id == u.id,
      select: %{inserted_at: s.inserted_at, ttl: s.ttl, email: u.email, token: s.token }
    ) |> map (&(put(&1, :seconds_left, sec_left(&1.inserted_at, &1.ttl))))
  end

  def open(for_user: user) do
    session_changeset = Session.create_changeset(%Session{}, %{user_id: user.id, ttl: ttl})
    Repo.insert(session_changeset)
  end

  defp ttl, do: Point.Config.get :session_ttl
end
