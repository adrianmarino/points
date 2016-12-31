defmodule Point.Repo do
  use Ecto.Repo, otp_app: :point
  import Enum

  def insert_all(entities), do: entities |> each(&insert!/1)

  def assoc(model, name), do: one Ecto.assoc(model, name)

  def refresh(%Point.Account{} = model), do: get!(Point.Account, model.id)
  def refresh(%Point.Currency{} = model), do: get!(Point.Currency, model.id)
  def refresh(%Point.Entity{} = model), do: get!(Point.Entity, model.id)
  def refresh(%Point.ExchangeRate{} = model), do: get!(Point.ExchangeRate, model.id)
  def refresh(%Point.Movement{} = model), do: get!(Point.Movement, model.id)
  def refresh(%Point.Session{} = model), do: get!(Point.Session, model.id)
  def refresh(%Point.User{} = model), do: get!(Point.User, model.id)
end
