defmodule Point.Repo do
  use Ecto.Repo, otp_app: :point
  import Enum

  def insert_all(entities), do: entities |> each(&insert!/1)

  def assoc(model, name), do: one Ecto.assoc(model, name)
end
