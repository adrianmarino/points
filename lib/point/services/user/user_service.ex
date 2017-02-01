defmodule Point.UserService do
  alias Point.{Repo, User}
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  # Auth
  def check(that_user: user, has_password: password), do: checkpw(password, user.password_hash)
  def dummy_check_password(), do: dummy_checkpw

  # Crud
  def all, do: Repo.all(User)
  def by(email: email), do: Repo.get_by(User, email: email)
  def register(params), do: Repo.insert(User.insert_changeset(%User{}, params))
  def register!(params), do: Repo.insert!(User.insert_changeset(%User{}, params))
  def update(email, params), do: Repo.update(User.update_changeset(by(email: email), params))
  def delete!(email: email), do: Repo.delete!(by(email: email))
end
