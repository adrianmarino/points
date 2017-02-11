defmodule Point.MovementSearcherSpec do
  use ESpec
  alias Point.{AccountFactory, TransferService}

  describe "search account movement before timestamp" do
    let movements: described_module.search(for: account, before: time)
    let time: Timex.shift(Timex.now, minutes: -1)
    let backup: AccountFactory.insert(:revel_backup)

    context "when there is a movement within last minute" do
      let source: AccountFactory.insert(:obiwan_kenoby_revel, issuer: backup.owner)
      let target: AccountFactory.insert(:han_solo_revel, issuer: backup.owner, currency: source.currency)
      let amount: Decimal.new 10.12
      let account: source
      let movement: List.first(movements)

      before do: TransferService.transfer(from: source, to: target, amount: amount)

      context "when search movements from an account" do
        let account: source
        it "returns movements", do: movements |> to(have_length 1)
        it "returns a transfer movement", do: expect movement.type |> to(eq "transfer")
        it "returns a from source account", do: expect movement.source_id |> to(eq account.id)
      end

      context "when search movements to an account" do
        let account: target
        it "returns movements", do: movements |> to(have_length 1)
        it "returns a transfer movement", do: expect movement.type |> to(eq "transfer")
        it "returns a from source account", do: expect movement.target_id |> to(eq account.id)
      end
    end

    context "when there aren't movement within last minute" do
      let account: backup
      it "doesn't return movements", do: movements |> to(have_length 0)
    end
  end
end
