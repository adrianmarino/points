defmodule Point.SessionService do
  import Ecto.Query
  alias Point.{Repo, Session, User}

  def all() do
    Repo.all(
      from s in Session, join: u in User,
      where: s.user_id == u.id,
      select: %{email: u.email, token: s.token}
    )
  end

  def open(for_user: user) do
    session_changeset = Session.create_changeset(%Session{}, %{user_id: user.id})
    Repo.insert(session_changeset)
  end
end
