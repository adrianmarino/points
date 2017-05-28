defmodule Point.TransferServiceSpec do
  use ESpec
  import ServiceSpecHelper
  import Decimal
  alias Point.{AccountFactory, EntityFactory}

  let amount: Decimal.new 10.12
  let transfer: described_module().transfer(from: source(), to: target(), amount: amount())
  let rebelion: EntityFactory.insert(:rebelion)

  context "when transfer amount between accounts with same currency" do
    let source: AccountFactory.insert(:obiwan_kenoby, entity: rebelion())
    let target: AccountFactory.insert(:han_solo, entity: rebelion())

    it "should creates an transfer movement", do: expect(transfer().type).to(eq "transfer")

    it "should increases target account balance to transfered amount" do
      expect fn-> transfer() end |> to(change amount(target()), plus(target(), amount()))
    end

    it "should decreases source account balance to transfered amount" do
      expect fn-> transfer() end |> to(change amount(source()), minus(source(), amount()))
    end

    it "creates a movement with an expected target account" do
      expect(target_id(transfer())).to(eq target().id)
    end

    it "creates a movement with an expected source account" do
      expect(source_id(transfer())).to(eq source().id)
    end

    it "creates a movement with trasfered amount", do: expect(transfer().amount).to(eq amount())
  end

  context "when transfer amount between accounts with distinct currency" do
    let source: AccountFactory.insert(:han_solo, entity: rebelion())
    let target: AccountFactory.insert(:jango_fett, entity: rebelion())

    let source_target_rate: rate(source(), target(), 2).value

    before do: source_target_rate()

    it "should creates transfer movement", do: expect(transfer().type).to(eq "transfer")

    it "should decreases source account to transfered amount" do
      expect fn-> transfer() end |> to(change amount(source()), minus(source(), amount()))
    end

    it "should increases target account to transfered amount" do
      final_amount = round(add(target().amount, mult(amount(), source_target_rate())), 2)

      expect fn-> transfer() end |> to(change amount(target()), final_amount)
    end

    it "creates a movement with an expected target account" do
      expect(target_id(transfer())).to(eq target().id)
    end

    it "creates a movement with an expected source account" do
      expect(source_id(transfer())).to(eq source().id)
    end

    it "creates a movement with trasfered amount", do: expect(transfer().amount).to(eq amount())
  end

  context "when transfer money between accounts under entities that aren't partners" do
    let source: AccountFactory.insert(:han_solo, entity: rebelion())
    let target: AccountFactory.insert(:jango_fett, entity: EntityFactory.insert(:empire))

    it "should be disalowed", do: expect fn-> transfer() end |> to(raise_exception())
  end
end
