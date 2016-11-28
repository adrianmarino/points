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

  def obiwan_factory do
    %Account{
      type: "default",
      amount: Decimal.new(5000),
      currency: CurrencyFactory.build(:rio_point),
      owner: UserFactory.build(:obiwan_kenoby),
      issuer: UserFactory.build(:root)
    }
  end

  def quigon_factory do
    %Account{
      type: "default",
      amount: Decimal.new(10000),
      currency: CurrencyFactory.build(:santander_point),
      owner: UserFactory.build(:quigon_jinn),
      issuer: UserFactory.build(:root)
    }
  end
end
