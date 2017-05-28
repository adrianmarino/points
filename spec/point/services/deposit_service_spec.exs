defmodule Point.DepositServiceSpec do
  use ESpec
  import ServiceSpecHelper
  import ServiceSpecHelper
  alias Point.{EntityFactory, AccountFactory}

  let amount: Decimal.new 10.12
  let rebelion: EntityFactory.insert(:rebelion)
  let account: AccountFactory.insert(:han_solo, entity: rebelion())
  let deposit: described_module().deposit(amount: amount(), to: account())

  context "when deposit to account" do
    it "should increases account balance up to deposited amount" do
      expect fn-> deposit() end |> to(change amount(account()), plus(account(), amount()))
    end

    it "should creates a movement with the account as target acount" do
      expect(target_id(deposit())).to(eq account().id)
    end

    it "should creates a movement with the deposited amount", do: expect(deposit().amount).to(eq amount())

    it "should creates a deposit movement", do: expect(deposit().type).to(eq "deposit")
  end
end
