defmodule Point.AccountFactory do
  use ExMachina.Ecto, repo: Point.Repo
  alias Point.{Account, CurrencyFactory, UserFactory, EntityFactory}

  def obiwan_kenoby_factory do
    %Account{
      amount: Decimal.new(15000),
      currency: CurrencyFactory.build(:rebel_point),
      owner: UserFactory.build(:obiwan_kenoby),
      issuer: UserFactory.build(:luke_skywalker),
    }
  end

  def han_solo_factory do
    %Account{
      amount: Decimal.new(15000),
      currency: CurrencyFactory.build(:rebel_point),
      owner: UserFactory.build(:han_solo),
      issuer: UserFactory.build(:luke_skywalker)
    }
  end

  def jango_fett_factory do
    %Account{
      amount: Decimal.new(15000),
      currency: CurrencyFactory.build(:empire_point),
      owner: UserFactory.build(:jango_fett),
      issuer: UserFactory.build(:anakin_skywalker)
    }
  end
end
