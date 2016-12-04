defmodule Point.DepositServiceSpec do
  use ESpec
  alias Point.AccountFactory
  import ServiceSpecHelper
  import Point.Repo
  import Decimal
  import ServiceSpecHelper

  let amount: Decimal.new 100.1234567891

  describe "deposit" do
    let deposit: ok_result(described_module.deposit(amount: amount, on: account))

    context "when deposit an amount to issuer backup account" do
      let account: AccountFactory.insert(:revel_backup)

      it "should increases account balance for deposited amount" do
        expect fn-> deposit end |> to(change amount(account), round(add(account.amount, amount),2))
      end

      it "creates a movement with account as target acount" do
        expect(assoc(deposit, :target).id).to(eq account.id)
      end

      it "creates a movement with deposited amount", do: expect(deposit.amount).to(eq amount)
    end

    context "when deposit an amount to user account" do
      let account: AccountFactory.insert(:obiwan_kenoby_revel)
      it "should raise and error", do: expect fn-> deposit end |> to(raise_exception)
    end
  end
end
