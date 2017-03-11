defmodule Point.Repo.Migrations.AddRoleToUsers do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :role, :integer
    end
  end

  def down do
    alter table(:users) do
      remove :role
    end
  end
end
