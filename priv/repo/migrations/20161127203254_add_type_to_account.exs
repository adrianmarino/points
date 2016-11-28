defmodule Point.Repo.Migrations.AddTypeToAccount do
  use Ecto.Migration

  def up do
    alter table(:accounts) do
      add :type, :string
    end
  end

  def down do
    alter table(:accounts) do
      drop :type
    end
  end
end
