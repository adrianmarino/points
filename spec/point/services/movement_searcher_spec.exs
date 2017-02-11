defmodule Point.MovementSearcherSpec do
  use ESpec
  alias Point.{AccountFactory, TransferService}

  describe "before" do
    let movements: described_module.before(time: time)
    let time: Timex.shift(Timex.now, minutes: -1)

    context "when there is a movement within last minute" do
      let backup: AccountFactory.insert(:revel_backup)
      let source: AccountFactory.insert(:obiwan_kenoby_revel, issuer: backup.owner)
      let target: AccountFactory.insert(:han_solo_revel, issuer: backup.owner, currency: source.currency)
      let amount: Decimal.new 10.12
      let movement: List.first(movements)

      before do: TransferService.transfer(from: source, to: target, amount: amount)

      it "returns movements", do: movements |> to(have_length 1)
      it "returns a trasnfer movement", do: expect movement.type |> to(eq "transfer")
    end

    it "doesn't return movements when there aren't movement within last minute", do: movements |> to(have_length 0)
  end
end
