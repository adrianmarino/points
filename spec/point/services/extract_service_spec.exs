defmodule Point.ExtractServiceSpec do
  use ESpec
  import ServiceSpecHelper
  alias Point.{EntityFactory, AccountFactory}

  let rebelion: EntityFactory.insert(:rebelion)
  let account: AccountFactory.insert(:han_solo, entity: rebelion())
  let extract: described_module().extract(amount: amount(), from: account())

  context "when extract from account" do
    let amount: Decimal.new 10.12

    it "should decrements account to required amount" do
      expect fn-> extract() end |> to(change amount(account()), minus(account(), amount()))
    end

    it "should creates an extract movement", do: expect(extract().type).to(eq "extract")
  end
end
