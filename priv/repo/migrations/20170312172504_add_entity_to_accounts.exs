defmodule Point.Repo.Migrations.AddEntityToAccounts do
  use Ecto.Migration

  def up do
    alter table(:accounts) do
      add :entity_id, references(:entities)
    end
  end

  def down do
    alter table(:accounts) do
      drop :entity_id
    end
  end
end
