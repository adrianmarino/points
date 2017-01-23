defmodule Point.Repo.Migrations.AddIssuerToTransaction do
  use Ecto.Migration

  def up do
    alter table(:transactions) do
      add :issuer_id, references(:users)
    end
  end

  def down do
    alter table(:transactions) do
      remove :issuer_id
    end
  end
end
