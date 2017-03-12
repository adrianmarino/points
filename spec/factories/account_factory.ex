defmodule Point.AccountFactory do
  use ExMachina.Ecto, repo: Point.Repo
  alias Point.{Account, CurrencyFactory, UserFactory, EntityFactory}

  def universe_backup_factory do
    %Account{
      type: "backup",
      amount: Decimal.new(15000),
      currency: CurrencyFactory.build(:ars),
      owner: UserFactory.build(:chewbacca),
      entity: EntityFactory.insert(:universe)
    }
  end

  def revel_backup_factory do
    %Account{
      type: "backup",
      amount: Decimal.new(15000),
      currency: CurrencyFactory.build(:ars),
      owner: UserFactory.build(:luke_skywalker),
      issuer: UserFactory.build(:chewbacca),
      entity: EntityFactory.insert(:rebelion)
    }
  end

  def obiwan_kenoby_factory do
    %Account{
      type: "default",
      amount: Decimal.new(15000),
      currency: CurrencyFactory.build(:rebel_point),
      owner: UserFactory.build(:obiwan_kenoby),
      issuer: UserFactory.build(:luke_skywalker)
    }
  end

  def han_solo_factory do
    %Account{
      type: "default",
      amount: Decimal.new(15000),
      currency: CurrencyFactory.build(:rebel_point),
      owner: UserFactory.build(:han_solo),
      issuer: UserFactory.build(:luke_skywalker)
    }
  end

  def empire_backup_factory do
    %Account{
      type: "backup",
      amount: Decimal.new(15000),
      currency: CurrencyFactory.build(:ars),
      owner: UserFactory.build(:anakin_skywalker),
      issuer: UserFactory.build(:chewbacca),
      entity: EntityFactory.insert(:empire)
    }
  end

  def jango_fett_factory do
    %Account{
      type: "default",
      amount: Decimal.new(15000),
      currency: CurrencyFactory.build(:empire_point),
      owner: UserFactory.build(:jango_fett),
      issuer: UserFactory.build(:anakin_skywalker)
    }
  end
end
