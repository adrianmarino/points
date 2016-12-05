defmodule Point.Repo.Migrations.AddUniqueIndexes do
  use Ecto.Migration

  def up do
    create unique_index(:users, [:email])
    create unique_index(:currencies, [:code])
    create unique_index(:exchange_rates, [:source_id, :target_id])
  end
end
