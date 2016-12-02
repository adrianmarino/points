defmodule Point.AccountFactory do
  use ExMachina.Ecto, repo: Point.Repo
  alias Point.{Account, CurrencyFactory, UserFactory}

  def universe_backup_factory do
    %Account{
      type: "universe-backup",
      amount: Decimal.new(15000),
      currency: CurrencyFactory.build(:ars),
      owner: UserFactory.build(:chewbacca)
    }
  end


  def revel_backup_factory do
    %Account{
      type: "backup",
      amount: Decimal.new(15000),
      currency: CurrencyFactory.build(:ars),
      owner: UserFactory.build(:luke_skywalker),
      issuer: UserFactory.build(:chewbacca)
    }
  end

  def obiwan_kenoby_revel_factory do
    %Account{
      type: "default",
      amount: Decimal.new(10000),
      currency: CurrencyFactory.insert(:revel_point),
      owner: UserFactory.insert(:obiwan_kenoby),
      issuer: UserFactory.insert(:luke_skywalker)
    }
  end

  def han_solo_revel_factory do
    %Account{
      type: "default",
      amount: Decimal.new(10000),
      currency: CurrencyFactory.insert(:revel_point),
      owner: UserFactory.insert(:han_solo),
      issuer: UserFactory.insert(:luke_skywalker)
    }
  end


  def empire_backup_factory do
    %Account{
      type: "backup",
      amount: Decimal.new(15000),
      currency: CurrencyFactory.build(:ars),
      owner: UserFactory.build(:anakin_skywalker),
      issuer: UserFactory.build(:chewbacca)
    }
  end

  def jango_fett_empire_factory do
    %Account{
      type: "default",
      amount: Decimal.new(5000),
      currency: CurrencyFactory.build(:empire_point),
      owner: UserFactory.build(:jango_fett),
      issuer: UserFactory.build(:anakin_skywalker)
    }
  end
end
