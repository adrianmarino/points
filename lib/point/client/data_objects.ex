defmodule Point.Client.User do
  defstruct [:email, :password, :first_name, :last_name]

  def create(params) do
    %Point.Client.User{
      email: Enum.at(params, 0),
      password: Enum.at(params, 1),
      first_name: Enum.at(params, 2),
      last_name: Enum.at(params, 3)
    }
  end
end

defmodule Point.Client.ExchangeRate do
  defstruct [:source, :target, :value]

  def create(params) do
    %Point.Client.ExchangeRate{
      source: Enum.at(params, 0),
      target: Enum.at(params, 1),
      value: Enum.at(params, 2)
    }
  end
end

defmodule Point.Client.Account do
  defstruct [:owner_email, :currency_code]

  def create(params) do
    %Point.Client.Account{owner_email: Enum.at(params, 0), currency_code: Enum.at(params, 1)}
  end
end
