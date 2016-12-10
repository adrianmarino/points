defmodule Point.Session do
  use Point.Web, :model

  schema "sessions" do
    field :token, :string
    field :ttl, :integer, default: 3600

    belongs_to :user, Point.User

    timestamps()
  end

  def changeset(model, params \\ :empty), do: model |> cast(params, ~w(user_id ttl), [])

  def create_changeset(model, params \\ :empty) do
    model |> changeset(params) |> put_change(:token, SecureRandom.urlsafe_base64())
  end
end
