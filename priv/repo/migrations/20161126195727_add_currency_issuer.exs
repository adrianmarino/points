defmodule Point.Repo.Migrations.AddCurrencyIssuer do
  use Ecto.Migration

  def up do
    alter table(:currencies) do
      add :issuer_id, references(:users)
    end
  end

  def down do
    alter table(:currencies) do
      drop :issuer_id
    end
  end
end
