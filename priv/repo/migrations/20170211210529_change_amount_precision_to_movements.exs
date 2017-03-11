defmodule Point.Repo.Migrations.ChangeAmountPrecisionToMovements do
  use Ecto.Migration

  def up do
    alter table(:movements) do
      modify :amount, :decimal, [precision: 20, scale: 10, null: false, default: 0]
    end
  end

  def down do
    alter table(:movements), do: modify :amount, :decimal
  end
end
