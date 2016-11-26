defmodule Point.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :amount, :decimal

      timestamps()
    end
  end
end
