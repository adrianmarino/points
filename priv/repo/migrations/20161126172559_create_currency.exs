defmodule Point.Repo.Migrations.CreateCurrency do
  use Ecto.Migration

  def change do
    create table(:currencies) do
      add :code, :string
      add :name, :string

      timestamps()
    end
  end
end
