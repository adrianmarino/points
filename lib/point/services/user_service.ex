defmodule Point.UserService do
  alias Point.{Repo, User}
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def by(email: email), do: Repo.get_by(User, email: email)

  def check(that_user: user, has_password: password), do: checkpw(password, user.password_hash)

  def dummy_check_password(), do: dummy_checkpw
end
