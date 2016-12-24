defmodule Point.CurrencyFactory do
  use ExMachina.Ecto, repo: Point.Repo
  alias Point.{Currency, UserFactory}

  def ars_factory, do: %Currency{code: sequence(:code, &"ARS#{&1}"), name: "Pesos", issuer: UserFactory.build(:chewbacca)}

  def shared_point_factory do
    %Currency{code: sequence(:code, &"SRD#{&1}"), name: "Shared Points", issuer: UserFactory.build(:chewbacca)}
  end

  def rebel_point_factory do
    %Currency{code: sequence(:code, &"RBL#{&1}"), name: "Rebel Points", issuer: UserFactory.build(:luke_skywalker)}
  end

  def empire_point_factory do
    %Currency{code: sequence(:code, &"EMP#{&1}"), name: "Empire Points", issuer: UserFactory.build(:anakin_skywalker)}
  end
end
