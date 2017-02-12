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

  let time: Timex.shift(Timex.now, minutes: -1)
  let str_time: elem(Timex.format(time, "{YYYY}{0M}{0D}_{h24}{m}"), 1)

  let movements: json_response(response, 200)
  let movement: List.first(movements)
  let movement_date: Timex.parse(movement["date"], "{ISO:Extended}")
  let movement_amount: round(movement["amount"], 2)

  before do: TransferService.transfer(from: source, to: target, amount: amount)

  describe "search movements after a timestamp" do
    let response: get(sec_conn, movement_path(sec_conn, :search_after, str_time))

    it "returns movements", do: movements |> to(have_length 1)
    it "returns a movement with an amount", do: expect movement_amount |> to(eq amount)
    it "returns a movement date greater than query date" do
      expect TimeUtil.is(movement_date, greater_or_equal_that: time) |> to(be_truthy)
    end
  end

  describe "search movements with account after timestamp" do
    let response: get(sec_conn,
      movement_path(sec_conn, :search_by_account_after, owner_email(source), currency_code(source), str_time))

    it "returns movements", do: movements |> to(have_length 1)
    it "returns a movement with an amount", do: expect movement_amount |> to(eq mult(-1, amount))
    it "returns a movement date greater than query date" do
      expect TimeUtil.is(movement_date, greater_or_equal_that: time) |> to(be_truthy)
    end
  end
end
