defmodule Elixir.Point.Repo.Migrations.AddManyUsersToManyEntities do
  use Ecto.Migration

  def up do
    create table(:users_entities) do
      add :user_id, references(:users)
      add :entity_id, references(:entities)

      timestamps
    end
  end

  def down do
    drop table(:users_entities)
  end
end
