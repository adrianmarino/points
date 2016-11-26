defmodule Point.Repo.Migrations.CreateEntity do
  use Ecto.Migration

  def change do
    create table(:entities) do
      add :name, :string

      timestamps()
    end
  end
end
