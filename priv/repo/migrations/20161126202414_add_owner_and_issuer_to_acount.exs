defmodule Point.Repo.Migrations.AddOwnerAndIssuerToAcount do
  use Ecto.Migration

  def up do
    alter table(:accounts) do
      add :owner_id, references(:users)
      add :issuer_id, references(:users)
    end
  end

  def down do
    alter table(:accounts) do
      drop :owner_id
      drop :issuer_id
    end
  end
end
