defmodule Point.CurrencyFactory do
  use ExMachina.Ecto, repo: Point.Repo
  alias Point.{Currency, UserFactory}

  def ars_factory, do: %Currency{code: "ARS", name: "Pesos", issuer: UserFactory.build(:chewbacca)}

  def revel_point_factory do
    %Currency{code: "RVL", name: "Revel Points", issuer: UserFactory.build(:luke_skywalker)}
  end

  def empire_point_factory do
    %Currency{code: "EMP", name: "Empire Points", issuer: UserFactory.build(:anakin_skywalker)}
  end
end
