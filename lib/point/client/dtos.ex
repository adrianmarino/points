defmodule Point.Client.Dto do
  defmodule Session do
    defstruct [:email, :password]
    def new([email, password]), do: %Session{email: email, password: password}
  end

  defmodule User do
    defstruct [:email, :password, :first_name, :last_name]
    def new([email, password, first_name, last_name]) do
      %User{email: email, password: password, first_name: first_name, last_name: last_name}
    end
  end

  defmodule Currency do
    defstruct [:code, :name]
    def new([code, name]), do: %Currency{code: code, name: name}
  end

  defmodule ExchangeRateId do
    defstruct [:source, :target]
    def new([source, target]), do: %ExchangeRateId{source: source, target: target}
  end

  defmodule ExchangeRate do
    defstruct [:source, :target, :value]
    def new([source, target, value]), do: %ExchangeRate{source: source, target: target, value: value}
  end

  defmodule Account do
    defstruct [:owner_email, :currency_code]
    def create([owner_email, currency_code]), do: %Account{owner_email: owner_email, currency_code: currency_code}
  end

  defmodule Transaction do
    defstruct [:name, :source]
    def new([name, source]), do: %Transaction{name: name, source: source}
  end
end
