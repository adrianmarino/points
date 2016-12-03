defmodule Point.ExchangeRateFactory do
  use ExMachina.Ecto, repo: Point.Repo
  alias Point.{ExchangeRate, CurrencyFactory}

  def ars_revel_point_factory do
    %ExchangeRate{
      source: CurrencyFactory.build(:ars),
      value: 1000,
      target: CurrencyFactory.build(:revel_point)
    }
  end

  def revel_point_ars_factory do
    %ExchangeRate{
      source: CurrencyFactory.build(:revel_point),
      value: 1/1000,
      target: CurrencyFactory.build(:ars)
    }
  end



  def ars_empire_point_factory do
    %ExchangeRate{
      source: CurrencyFactory.build(:ars),
      value: 500,
      target: CurrencyFactory.build(:empire_point)
    }
  end

  def empire_point_ars_factory do
    %ExchangeRate{
      source: CurrencyFactory.build(:empire_point),
      value: 1/500,
      target: CurrencyFactory.build(:ars)
    }
  end

  def revel_empire_point_factory do
    %ExchangeRate{
      source: CurrencyFactory.build(:revel_point),
      value: 0.5,
      target: CurrencyFactory.build(:empire_point)
    }
  end

  def empire_revel_point_factory do
    %ExchangeRate{
      source: CurrencyFactory.build(:empire_point),
      value: 2,
      target: CurrencyFactory.build(:revel_point)
    }
  end



  def ars_shared_point_factory do
    %ExchangeRate{
      source: CurrencyFactory.build(:ars),
      value: 1000,
      target: CurrencyFactory.build(:shared_point)
    }
  end

  def shared_point_ars_factory do
    %ExchangeRate{
      source: CurrencyFactory.build(:shared_point),
      value: 1/1000,
      target: CurrencyFactory.build(:ars)
    }
  end
end
