defmodule Point.Repo.Migrations.CreateExchangeRate do
  use Ecto.Migration

  def change do
    create table(:exchange_rates) do
      add :value, :decimal, [precision: 20, scale: 10, null: false]

      timestamps()
    end
  end
end
