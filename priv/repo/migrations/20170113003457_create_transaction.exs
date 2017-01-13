defmodule Point.Repo.Migrations.CreateTransaction do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :name, :string
      add :source, :mediumtext

      timestamps()
    end
    create index(:transactions, [:name])
  end
end
