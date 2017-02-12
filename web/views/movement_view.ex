defmodule Point.MovementView do
  use Point.Web, :view
  import Point.DecimalUtil
  import Enum, only: [map: 2]
  alias Point.{MovementView,  AccountService, Repo}

  def render("search.json",  %{movements: movements, account_id: account_id}) do
    movements |> map(&(to_account_movement &1, account_id))
  end

  def render("index.json", %{movements: movements}) do
    render_many(movements, MovementView,  "movement.json")
  end
  def render("movement.json", %{movement: movement}) do
    %{
      date: movement.inserted_at,
      amount: to_string(movement.amount),
      source: account_to_map(movement.source_id),
      target: account_to_map(movement.target_id)
    }
  end

  defp to_account_movement(movement, account_id) do
    %{date: movement.inserted_at, amount: to_string(mult(amount_sign(movement, account_id), movement.amount))}
  end
  defp amount_sign(movement, account_id) do
    case {movement.source_id, movement.target_id}  do
      {nil, _} -> 1
      {_, nil} -> -1
      {_, id} when id == account_id -> 1
      {id, _} when id == account_id -> -1
    end
  end
  defp account_to_map(account_id) do
    account = AccountService.get!(account_id)
    %{currency_code: Repo.assoc(account, :currency).code, owner_email: Repo.assoc(account, :owner).email}
  end
end
