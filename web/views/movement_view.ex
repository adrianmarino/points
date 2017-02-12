defmodule Point.MovementView do
  use Point.Web, :view
  import Point.DecimalUtil
  import Enum, only: [map: 2]
  alias Point.{MovementView, Repo}

  def render("search.json",  %{movements: movements, account_id: account_id}) do
    movements |> map(&(to_account_movement &1, account_id))
  end

  def render("index.json", %{movements: movements}) do
    render_many(movements, MovementView,  "movement.json")
  end
  def render("movement.json", %{movement: movement}) do
    source = Repo.assoc(movement, :source)
    source_currency_code = Repo.assoc(source, :currency).code
    target = Repo.assoc(movement, :target)
    target_currency_code = Repo.assoc(target, :currency).code
    %{
      date: movement.inserted_at,
      amount: movement.amount,
      source: %{email: source.owner_email, currency_code: source_currency_code},
      target: %{email: target.owner_email, currency_code: target_currency_code}
    }
  end

  def to_account_movement(movement, account_id) do
    %{date: movement.inserted_at, amount: mult(amount_sign(movement, account_id), movement.amount)}
  end
  def amount_sign(movement, account_id) do
    case {movement.source_id, movement.target_id}  do
      {nil, _} -> 1
      {_, nil} -> -1
      {_, id} when id == account_id -> 1
      {id, _} when id == account_id -> -1
    end
  end
end
