defmodule Point.Repo.Migrations.CreateExchangeRate do
  use Ecto.Migration

  def change do
    create table(:exchange_rates) do
      add :rate, :decimal

      timestamps()
    end
  end
end
