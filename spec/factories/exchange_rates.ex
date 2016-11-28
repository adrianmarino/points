defmodule Point.ExchangeRateFactory do
  use ExMachina.Ecto, repo: Point.Repo
  alias Point.{ExchangeRate, CurrencyFactory}

  def ars_std_point_factory do
    %ExchangeRate{
      rate: 1,
      source: CurrencyFactory.build(:ars),
      target: CurrencyFactory.build(:rio_point)
    }
  end

  def rio_point_ars_factory do
    %ExchangeRate{
      rate: 1,
      source: CurrencyFactory.build(:rio_point),
      target: CurrencyFactory.build(:ars)
    }
  end

  def ars_std_point_factory do
    %ExchangeRate{
      rate: 1,
      source: CurrencyFactory.build(:ars),
      target: CurrencyFactory.build(:std_point)
    }
  end

  def std_point_ars_factory do
    %ExchangeRate{
      rate: 1,
      source: CurrencyFactory.build(:std_point),
      target: CurrencyFactory.build(:ars)
    }
  end

  def rio_point_std_point_factory do
    %ExchangeRate{
      rate: 1,
      source: CurrencyFactory.build(:rio_point),
      target: CurrencyFactory.build(:std_point)
    }
  end

  def std_point_rio_point_factory do
    %ExchangeRate{
      rate: 1,
      source: CurrencyFactory.build(:std_point),
      target: CurrencyFactory.build(:rio_point)
    }
  end
end
