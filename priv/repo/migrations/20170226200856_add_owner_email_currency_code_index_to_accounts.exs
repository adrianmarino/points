defmodule Point.Repo.Migrations.AddOwnerEmailCurrencyCodeIndexToAccounts do
  use Ecto.Migration

  def change do
    create unique_index(:accounts, [:owner_id, :currency_id])
  end
end
