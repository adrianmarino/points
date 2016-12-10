defmodule Point.Repo.Migrations.AddTtlToSessions do
  use Ecto.Migration

  def up do
    alter table(:sessions) do
      add :ttl, :integer, [null: false]
    end
  end

  def down do
    alter table(:sessions) do
      remove :ttl
    end
  end
end
