defmodule Point.Repo.Migrations.AddCodeToEntities do
  use Ecto.Migration

  def up do
    alter table(:entities) do
      add :code, :string
    end
    create unique_index(:entities, :code)
  end

  def down do
    alter table(:entities) do
      remove :code
    end
  end
end
