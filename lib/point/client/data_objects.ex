defmodule Point.Client.Dto do
  defmodule Session do
    import Enum
    defstruct [:email, :password]
    def new(params) do
      %Session{email: at(params, 0), password: at(params, 1)}
    end
  end

  defmodule User do
    import Enum
    defstruct [:email, :password, :first_name, :last_name]
    def new(params) do
      %User{email: at(params, 0), password: at(params, 1), first_name: at(params, 2),
        last_name: at(params, 3)}
    end
  end

  defmodule Currency do
    import Enum
    defstruct [:code, :name]
    def new(params), do: %Currency{code: at(params, 0), name: at(params, 1)}
  end

  defmodule ExchangeRateId do
    import Enum
    defstruct [:source, :target]
    def new(params), do: %ExchangeRateId{source: at(params, 0), target: at(params, 1)}
  end
  defmodule ExchangeRate do
    import Enum
    defstruct [:source, :target, :value]
    def new(params), do: %ExchangeRate{source: at(params, 0), target: at(params, 1), value: at(params, 2)}
  end

  defmodule Account do
    import Enum
    defstruct [:owner_email, :currency_code]
    def create(params), do: %Account{owner_email: at(params, 0), currency_code: at(params, 1)}
  end

  defmodule Transaction do
    import Enum
    defstruct [:name, :source]
    def new(params), do: %Transaction{name: at(params, 0), source: at(params, 1)}
  end
end
