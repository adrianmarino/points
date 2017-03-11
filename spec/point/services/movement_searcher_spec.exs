defmodule Point.MovementSearcherSpec do
  use ESpec
  import ServiceSpecHelper
  alias Point.{AccountFactory, TransferService}

  describe "search account movements before timestamp" do
    let movements: described_module().search(for: account(), after: time())
    let time: Timex.shift(Timex.now, minutes: -1)
    let backup: AccountFactory.insert(:revel_backup)

    context "when there is a movement within last minute" do
      let source: AccountFactory.insert(:obiwan_kenoby_revel, issuer: backup().owner)
      let target: AccountFactory.insert(:han_solo_revel, issuer: backup().owner, currency: source().currency)
      let amount: Decimal.new 10.12
      let account: source()
      let movement: List.first(movements())
      let one: Decimal.new(1)

      before do: TransferService.transfer(from: source(), to: target(), amount: amount())

      context "when search movements by source account" do
        let account: source()
        it "returns movements", do: movements() |> to(have_length 1)
        it "returns a transfer movement", do: expect movement().type |> to(eq "transfer")
        it "returns a movement with account as source", do: expect movement().source_id |> to(eq account().id)
        it "returns a movement with a target account", do: expect movement().target_id |> to(eq target().id)
        it "returns a movement with an amount", do: expect amount(movement()) |> to(eq amount())
        it "returns a movement with an rate", do: expect movement().rate |> to(eq one())
      end

      context "when search movements by target account" do
        let account: target()
        it "returns movements", do: movements() |> to(have_length 1)
        it "returns a transfer movement", do: expect movement().type |> to(eq "transfer")
        it "returns a movement with account as source", do: expect movement().target_id |> to(eq account().id)
        it "returns a movement with a target account", do: expect movement().target_id |> to(eq target().id)
        it "returns a movement with an amount", do: expect amount(movement()) |> to(eq amount())
        it "returns a movement with an rate", do: expect movement().rate |> to(eq one())
      end
    end

    context "when there aren't movement within last minute" do
      let account: backup()
      it "doesn't return movements", do: movements() |> to(have_length 0)
    end
  end
end
