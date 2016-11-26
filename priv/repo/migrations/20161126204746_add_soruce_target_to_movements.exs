defmodule Point.Repo.Migrations.AddSoruceTargetToMovements do
  use Ecto.Migration

  def up do
    alter table(:movements) do
      add :source_id, references(:accounts)
      add :target_id, references(:accounts)
    end
  end

  def down do
    alter table(:movements) do
      drop :source_id
      drop :target_id
    end
  end
end
