defmodule Point.MovementControllerSpec do
  use ESpec.Phoenix, controller: Point.MovementController
  use ESpec.Phoenix.Helper
  import ServiceSpecHelper
  import Point.DecimalUtil
  alias Point.{AccountFactory, TransferService, TimeUtil}

  let backup: AccountFactory.insert(:revel_backup)
  let source: AccountFactory.insert(:obiwan_kenoby_revel, issuer: backup.owner)
  let target: AccountFactory.insert(:han_solo_revel, issuer: backup.owner, currency: source.currency)
  let amount: Decimal.new 10.12

  let movements: json_response(response, 200)
  let movement: List.first(movements)
  let movement_date: Timex.parse(movement["date"], "{ISO:Extended}")
  let movement_amount: round(movement["amount"], 2)

  before do: TransferService.transfer(from: source, to: target, amount: amount)

  describe "search movements between dates" do
    let from: Timex.shift(Timex.now, minutes: -5)
    let to: Timex.shift(Timex.now, minutes: 5)
    let response: get(sec_conn, movement_path(sec_conn, :search_between, to_str(from), to_str(to)))

    it "returns movements", do: movements |> to(have_length 1)
    it "returns a movement with an amount", do: expect movement_amount |> to(eq amount)
    it "returns a movement with a source account with currency code" do
      expect movement["source"]["currency_code"] |> to(eq currency_code(source))
    end
    it "returns a movement with a target account with currency code" do
      expect movement["target"]["currency_code"] |> to(eq currency_code(target))
    end
    it "returns a movement with a source account with owner email" do
      expect movement["source"]["owner_email"] |> to(eq owner_email(source))
    end
    it "returns a movement with a target account with owner email" do
      expect movement["target"]["owner_email"] |> to(eq owner_email(target))
    end
    it "returns a movement with date >= from" do
      expect TimeUtil.is(movement_date, greater_or_equal_that: from) |> to(be_truthy)
    end
    it "returns a movement with date <= to" do
      expect TimeUtil.is(to, greater_or_equal_that: movement_date) |> to(be_truthy)
    end
  end

  describe "search movements with account after timestamp" do
    let time: Timex.shift(Timex.now, minutes: -1)
    let response: get(sec_conn,
      movement_path(sec_conn, :search_by_account_after, owner_email(source), currency_code(source), to_str(time)))

    it "returns movements", do: movements |> to(have_length 1)
    it "returns a movement with an amount", do: expect movement_amount |> to(eq mult(-1, amount))
    it "returns a movement with date >= time" do
      expect TimeUtil.is(movement_date, greater_or_equal_that: time) |> to(be_truthy)
    end
  end

  defp to_str(time), do: elem(Timex.format(time, "{YYYY}{0M}{0D}_{h24}{m}"), 1)
end
