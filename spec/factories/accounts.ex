defmodule Point.AccountFactory do
  use ExMachina.Ecto, repo: Point.Repo
  alias Point.{Account, CurrencyFactory, UserFactory}

  def backup_factory do
    %Account{
      type: "backup",
      amount: Decimal.new(15000),
      currency: CurrencyFactory.build(:ars),
      owner: UserFactory.build(:root),
      issuer: UserFactory.build(:root)
    }
  end

  def obiwan_rio_factory do
    %Account{
      type: "default",
      amount: Decimal.new(5000),
      currency: CurrencyFactory.build(:rio_point),
      owner: UserFactory.build(:obiwan_kenoby),
      issuer: UserFactory.build(:root)
    }
  end

  def anakin_rio_factory do
    %Account{
      type: "default",
      amount: Decimal.new(5000),
      currency: CurrencyFactory.build(:rio_point),
      owner: UserFactory.build(:anakin_skywalker),
      issuer: UserFactory.build(:root)
    }
  end

  def quigon_std_factory do
    %Account{
      type: "default",
      amount: Decimal.new(10000),
      currency: CurrencyFactory.insert(:santander_point),
      owner: UserFactory.insert(:quigon_jinn),
      issuer: UserFactory.insert(:root)
    }
  end
end
