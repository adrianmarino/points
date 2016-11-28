defmodule Point.CurrencyFactory do
  use ExMachina.Ecto, repo: Point.Repo
  alias Point.{Currency, UserFactory}

  def ars_factory, do: %Currency{code: "ARS", name: "Pesos", issuer: UserFactory.build(:root)}

  def rio_point_factory do
    %Currency{code: "RIO", name: "Rio Points", issuer: UserFactory.build(:root)}
  end

  def std_point do
    %Currency{code: "STD", name: "Santander Points", issuer: UserFactory.build(:root)}
  end
end
