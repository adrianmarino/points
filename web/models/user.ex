defmodule Point.User do
  @moduledoc """
  Represent a platform user. A user:
    - Could be a issuer or a normal user.
    - Belong to entities.
    - Could issue currency.
    - Has accounts.
  """
  use Point.Web, :model
  import Point.EctoModel

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :first_name, :string
    field :last_name, :string

    many_to_many :entities, Point.Entity, join_through: "users_entities"
    has_many :currencies, Point.Currency

    timestamps()
  end

  def first_last_name_changeset(model, params \\ %{}) do
    model |> cast_and_validate_required(params, [:first_name, :last_name])
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: value}} ->
        changeset |> put_change(:password_hash, Comeonin.Bcrypt.hashpwsalt(value))
      _ -> changeset
    end
  end

  def password_changeset(model, params \\ %{}) do
    model
      |> cast_and_validate_required(params, [:password])
      |> validate_length(:password, min: 10)
      |> put_password_hash
  end

  def email_changeset(model, params \\ %{}) do
    model
      |> cast_and_validate_required(params, [:email])
      |> validate_length(:email, min: 6, max: 255)
      |> validate_format(:email, ~r/@/)
  end

  def insert_changeset(model, params \\ %{}) do
    model
      |> email_changeset(params)
      |> password_changeset(params)
      |> first_last_name_changeset(params)
  end

  def update_changeset(model, params \\ %{}) do
    model
      |> first_last_name_changeset(params)
      |> password_changeset(params)
  end
end
