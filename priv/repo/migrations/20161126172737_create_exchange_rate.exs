defmodule Point.Repo.Migrations.CreateExchangeRate do
  use Ecto.Migration

  def change do
    create table(:exchange_rates) do
      add :rate, :decimal, [precision: 20, scale: 20, null: false]

      timestamps()
    end
  end
end
