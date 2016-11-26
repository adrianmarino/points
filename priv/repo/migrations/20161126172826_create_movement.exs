defmodule Point.Repo.Migrations.CreateMovement do
  use Ecto.Migration

  def change do
    create table(:movements) do
      add :type, :string
      add :amount, :decimal
      add :rate, :decimal

      timestamps()
    end
  end
end
