defmodule Point.Repo.Migrations.AddRemoteIpToSessions do
  use Ecto.Migration

  def up do
    alter table(:sessions) do
      add :remote_ip, :string, [null: false]
    end
    create index(:sessions, [:remote_ip])
  end

  def down do
    alter table(:sessions) do
      remove :remote_ip
    end
  end
end
