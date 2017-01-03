defmodule Point.DepositServiceSpec do
  use ESpec
  import ServiceSpecHelper
  alias Point.AccountFactory
  import ServiceSpecHelper
  import Point.Repo

  let amount: Decimal.new 10.12
  let deposit: ok_result(described_module.deposit(amount: amount, to: account))

  context "when deposit an amount to issuer backup account" do
    let account: AccountFactory.insert(:revel_backup)

    it "should increases account balance up to deposited amount" do
      expect fn-> deposit end |> to(change amount(account), plus(account, amount))
    end

    it "should creates a movement with the account as target acount" do
      expect(assoc(deposit, :target).id).to(eq account.id)
    end

    it "should creates a movement with the deposited amount", do: expect(deposit.amount).to(eq amount)
  end

  context "when deposit an amount to default account" do
    let account: AccountFactory.insert(:obiwan_kenoby_revel)

    it "should raises and error", do: expect fn-> deposit end |> to(raise_exception)
  end
end
