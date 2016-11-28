defmodule Point.Repo do
  use Ecto.Repo, otp_app: :point
  import Enum
  alias Point.Model

  def insert_all(entities), do: entities |> each(&insert!/1)

  def assoc(model, name) do
    one Ecto.assoc(model, name)
  end

  def save(model, fields), do: update Model.changeset(model, fields)

  def refresh(model), do: Model.refresh(model)
end
