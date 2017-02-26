defmodule Point.SessionService do
  import Ecto.Query
  import Point.Ecto.DateTimeUtil
  import Enum, only: [map: 2]
  import Map, only: [put: 3]
  alias Point.{Repo, Session, User, Config}

  def all() do
    Repo.all(
      from s in Session, join: u in User,
      where: s.user_id == u.id,
      select: %{inserted_at: s.inserted_at, ttl: s.ttl, email: u.email, token: s.token, remote_ip: s.remote_ip})
    |> map((&(put(&1, :seconds_left, sec_left(&1.inserted_at, &1.ttl)))))
  end

  def open(for_user: user, from: remote_ip) do
    allowed_count = simultaneous_sessions_by_user_and_remote_ip
    case count_by(user: user, and_remote_ip: remote_ip) do
      count when count >= allowed_count -> {:error, "Only up to #{allowed_count} sessions per user and ip"}
      _ ->
        session_changeset = Session.create_changeset(%Session{}, %{user_id: user.id, ttl: ttl, remote_ip: remote_ip})
        Repo.insert(session_changeset)
    end
  end

  def close(token: token) do
    case by(token: token) do
      nil -> { :error, "Session doesn't found for #{token} token"}
      session -> Repo.delete(session)
    end
  end

  def by(token: token), do: Repo.one(from s in Session, where: s.token == ^token)

  defp count_by(user: user, and_remote_ip: remote_ip) do
    Repo.one(from s in Session,
      where: s.user_id == ^user.id and s.remote_ip == ^remote_ip,
      select: count(s.id))
  end

  defp ttl, do: Config.get :session_ttl
  defp simultaneous_sessions_by_user_and_remote_ip, do: Config.get :simultaneous_sessions_by_user_and_remote_ip
end
