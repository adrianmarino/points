defmodule Point.Repo.Migrations.RenamePasswordToPasswordHashInUsers do
  use Ecto.Migration

  def up do
    alter table(:users) do
      remove :password
      add :password_hash, :string, [null: false]
    end
  end
  def down do
    alter table(:users) do
      remove :password_hash
      add :password, :string
    end
  end
end
