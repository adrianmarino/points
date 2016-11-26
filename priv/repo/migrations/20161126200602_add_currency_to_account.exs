defmodule Point.Repo.Migrations.AddCurrencyToAccount do
  use Ecto.Migration

  def up do
    alter table(:accounts) do
      add :currency_id, references(:currencies)
    end
  end

  def down do
    alter table(:accounts) do
      drop :currency_id
    end
  end
end
