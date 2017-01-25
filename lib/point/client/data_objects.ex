defmodule Point.Client.User do
  import Enum
  defstruct [:email, :password, :first_name, :last_name]
  def create(params) do
    %Point.Client.User{email: at(params, 0), password: at(params, 1), first_name: at(params, 2),
      last_name: at(params, 3)}
  end
end

defmodule Point.Client.ExchangeRate do
  import Enum
  defstruct [:source, :target, :value]
  def create(params), do: %Point.Client.ExchangeRate{source: at(params, 0), target: at(params, 1), value: at(params, 2)}
end

defmodule Point.Client.Account do
  import Enum
  defstruct [:owner_email, :currency_code]
  def create(params), do: %Point.Client.Account{owner_email: at(params, 0), currency_code: at(params, 1)}
end

defmodule Point.Client.Transaction do
  import Enum
  defstruct [:name, :source]
  def create(params), do: %Point.Client.Transaction{name: at(params, 0), source: at(params, 1)}
end
