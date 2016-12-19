defmodule Point.UserService do
  alias Point.{Repo, User}
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def by(email: email), do: Repo.get_by(User, email: email)

  # Auth
  def check(that_user: user, has_password: password), do: checkpw(password, user.password_hash)
  def dummy_check_password(), do: dummy_checkpw

  # Crud
  def all, do: Repo.all(User)
  def get!(id), do: Repo.get!(User, id)
  def register(params), do: Repo.insert(User.registration_changeset(%User{}, params))
  def update(id, params), do: Repo.insert(User.registration_changeset(get!(id), params))
  def delete!(id), do: Repo.delete!(get!(id))
end
