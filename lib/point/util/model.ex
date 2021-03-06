defmodule Point.Model do
  alias Point.{ModelMap, JSON}
  def to_string(model), do: to_map(model) |> JSON.to_pretty_json
  def to_map(model), do: ModelMap.to_map(model)
end

defprotocol Point.ModelMap, do: def to_map(model)

defimpl Point.ModelMap, for: Point.Currency, do: def to_map(model), do: model.code
defimpl Point.ModelMap, for: Point.Entity, do: def to_map(model), do: model.name
defimpl Point.ModelMap, for: Point.User, do: def to_map(model), do: model.email
defimpl Point.ModelMap, for: Point.Movement do
  alias Point.{Repo, ModelMap}

  def to_map(movement) do
    %{
      type: movement.type,
      source: account_to_map(Repo.assoc movement, :source),
      target: account_to_map(Repo.assoc movement, :target),
      amount: to_string(movement.amount)
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

  def to_map(%{type: "default"} = account) do
    %{
      owner: ModelMap.to_map(Repo.assoc account, :owner),
      amount: to_string(account.amount),
      currency: ModelMap.to_map(Repo.assoc account, :currency)
    }
  end

  def to_map(%{type: "backup"} = account) do
    %{
      type: account.type,
      currency: ModelMap.to_map(Repo.assoc account, :currency),
      amount: to_string(account.amount)
    }
  end
end
defimpl Point.ModelMap, for: Point.ExchangeRate do
  alias Point.{ModelMap, Repo}

  def to_map(exchange_rate) do
    %{
      value: to_string(exchange_rate.value),
      source: ModelMap.to_map(Repo.assoc exchange_rate, :source),
      target: ModelMap.to_map(Repo.assoc exchange_rate, :target)
    }
  end
end

defimpl Point.ModelMap, for: Point.Transaction do
  import Point.MapUtil
  def to_map(transaction), do: sub_map(transaction, [:name, :source])
end

defimpl Point.ModelMap, for: Any, do: def to_map(model), do: inspect(model)
