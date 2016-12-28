defmodule Point.Model, do: def to_string(model), do: inspect(Point.ModelMap.to_map model)
defprotocol Point.ModelMap, do: def to_map(model)

defimpl Point.ModelMap, for: Point.Currency do
  def to_map(model), do: %{code: model.code}
end
defimpl Point.ModelMap, for: Point.Entity do
  def to_map(model), do: %{name: model.name}
end
defimpl Point.ModelMap, for: Point.User do
  def to_map(model), do: %{email: model.email}
end
defimpl Point.ModelMap, for: Point.Movement do
  alias Point.{Repo, ModelMap}

  def to_map(movement) do
    %{
      type: movement.type,
      source: account_to_map(Repo.assoc movement, :source),
      target: account_to_map(Repo.assoc movement, :target),
      amount: Decimal.to_string(movement.amount)
    }
  end

  defp account_to_map(account) do
    case account do
      nil -> "non"
      account -> ModelMap.to_map(account)
    end
  end
end
defimpl Point.ModelMap, for: Point.Account do
  alias Point.{Repo, ModelMap}

  def to_map(account) do
    %{
      currency: ModelMap.to_map(Repo.assoc account, :currency),
      amount: Decimal.to_string(account.amount),
      type: account.type
    }
  end
end
defimpl Point.ModelMap, for: Point.ExchangeRate do
  alias Point.{ModelMap, Repo}

  def to_map(exchange_rate) do
    %{
      value: Decimal.to_string(exchange_rate.value),
      source: ModelMap.to_map(Repo.assoc exchange_rate, :source),
      target: ModelMap.to_map(Repo.assoc exchange_rate, :target)
    }
  end
end
