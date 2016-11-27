defmodule Point.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password, :string
      add :first_name, :string
      add :last_name, :string

      timestamps()
    end
  end
end
