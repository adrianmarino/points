defmodule Point.ExtractService do
  import PointLogger
  import Point.Repo
  import Point.AccountService
  import Point.MovementFactory
  alias Point.Account
  alias Ecto.Multi

  def extract(amount: _, from: %Account{type: "default"} = account) do
    raise "Must not extract amount from '#{assoc(account, :owner).email}' default account!. Only allowed with backup accounts."
  end
  def extract(amount: amount, from: %Account{type: "backup"} = account) do
      {:ok, %{extract: movement}} = Multi.new
        |> Multi.update(:decrease_amount, decrease_changeset(account, amount))
        |> Multi.insert(:extract, extract(account, amount))
        |> transaction

      debug(movement)
      movement
  end
end
