defmodule Point.Repo.Migrations.AddSoruceAndTargetToExchangeRates do
  use Ecto.Migration

  def up do
    alter table(:exchange_rates) do
      add :source_id, references(:currencies)
      add :target_id, references(:currencies)
    end
  end

  def down do
    alter table(:exchange_rates) do
      drop :source_id
      drop :target_id
    end
  end
end
