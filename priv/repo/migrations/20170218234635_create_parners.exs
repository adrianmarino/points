defmodule Point.Repo.Migrations.CreatePartners do
  use Ecto.Migration

  def up do
    create table(:partners) do
      add :entity_id, references(:entities, on_delete: :nothing), primary_key: true
      add :partner_id, references(:entities, on_delete: :nothing), primary_key: true

      timestamps
    end
    create unique_index(:partners, [:entity_id, :partner_id])
  end

  def down do
    drop table(:partners)
  end
end
