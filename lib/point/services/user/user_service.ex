defmodule Point.UserService do
  import Ecto.Query
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias Point.{Repo, User, EntityService}

  # Auth
  def check(that_user: user, has_password: password), do: checkpw(password, user.password_hash)

  def dummy_check_password(), do: dummy_checkpw()

  # Crud
  def all, do: Repo.all(User)

  def by(email: email), do: Repo.get_by(User, email: email)

  def by(entity: entity), do: Repo.all(by_entity_query(entity))

  def count_by(entity: entity), do: Repo.one(from u in by_entity_query(entity), select: count(u.id))

  def register(params, entity) do
    user = Repo.insert(User.insert_changeset(%User{}, params))
    try_add_to_entity(user, entity)
  end

  def register!(params, entity) do
    user = Repo.insert!(User.insert_changeset(%User{}, params))
    try_add_to_entity(user, entity)
  end

  def update(email, params), do: Repo.update(User.update_changeset(by(email: email), params))

  def delete!(email: email), do: Repo.delete!(by(email: email))

  defp by_entity_query(entity) do
    from u in User,
    join: ue in "users_entities",
    where: u.id == ue.user_id and ue.entity_id == ^entity.id
  end

  defp try_add_to_entity({:error, _} = user, _), do: user
  defp try_add_to_entity({:ok, %{role: role} = model} = user, entity) when role == :entity_admin do
    EntityService.add_issuer(entity, model)
    user
  end
  defp try_add_to_entity(user, _), do: user
end
