defmodule Point.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :amount, :decimal, [precision: 20, scale: 10, null: false, default: 0]

      timestamps()
    end
  end
end
