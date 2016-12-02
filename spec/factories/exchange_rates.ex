defmodule Point.ExchangeRateFactory do
  use ExMachina.Ecto, repo: Point.Repo
  alias Point.{ExchangeRate, CurrencyFactory}

  def ars_revel_point_factory do
    %ExchangeRate{
      rate: 1,
      source: CurrencyFactory.build(:ars),
      target: CurrencyFactory.build(:revel_point)
    }
  end

  def revel_point_ars_factory do
    %ExchangeRate{
      rate: 1,
      source: CurrencyFactory.build(:revel_point),
      target: CurrencyFactory.build(:ars)
    }
  end


  def ars_empire_point_factory do
    %ExchangeRate{
      rate: 1,
      source: CurrencyFactory.build(:ars),
      target: CurrencyFactory.build(:empire_point)
    }
  end

  def empire_point_ars_factory do
    %ExchangeRate{
      rate: 1,
      source: CurrencyFactory.build(:empire_point),
      target: CurrencyFactory.build(:ars)
    }
  end

  def revel_empire_point_factory do
    %ExchangeRate{
      rate: 1,
      source: CurrencyFactory.build(:revel_point),
      target: CurrencyFactory.build(:empire_point)
    }
  end

  def empire_revel_point_factory do
    %ExchangeRate{
      rate: 1,
      source: CurrencyFactory.build(:empire_point),
      target: CurrencyFactory.build(:revel_point)
    }
  end
end
