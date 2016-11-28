defmodule Point.Services.MovementServiceSpec do
  use ESpec
  alias Point.AccountFactory
  import Point.Repo
  import Decimal

  let amount: new 100.1234567891

  describe "deposit" do
    let deposit: described_module.deposit(amount: amount, on: account)

    context "when deposit an amount to issuer backup account" do
      let account: AccountFactory.insert(:backup)
      before do: deposit

      it "should increase account balance for deposited amount" do
        expect(refresh(account).amount).to eq(add account.amount, amount)
      end

      it "creates a movement with account as target acount" do
        expect(assoc(deposit, :target).id).to eq(account.id)
      end

      it "creates a movement with deposited amount", do: expect(deposit.amount).to eq(amount)
    end

    context "when deposit an amount to user account" do
      let account: AccountFactory.insert(:obiwan_rio)

      it "should raise and error" do
        expect fn() -> deposit end |> to(raise_exception())
      end
    end
  end

  describe "transfer" do
    context "when transfer an amount between user accounts with same currency" do
      let transfer: described_module.transfer(from: source, to: target, amount: amount)
      before do: transfer

      context "when accounts belong to same issuers" do
        let source: AccountFactory.insert(:obiwan_rio)
        let target: AccountFactory.insert(:anakin_rio)

        it "should increase target account balance to transfered amount" do
          expect(refresh(target).amount).to eq(add target.amount, amount)
        end

        it "should decrease source account balance to transfered amount" do
          expect(refresh(source).amount).to eq(sub source.amount, amount)
        end

        it "creates a movement with an expected target account" do
          expect(assoc(transfer, :target).id).to eq(target.id)
        end

        it "creates a movement with an expected source account" do
          expect(assoc(transfer, :source).id).to eq(source.id)
        end

        it "creates a movement with trasfered amount", do: expect(transfer.amount).to eq(amount)

        pending "shouldn't modifies issuer account amount"
      end

      context "when accounts belong to distinct issuers" do
        pending "should transfers an equivalent backup amount between issuer acounts"
        pending "should transfers amount between user acounts"
      end
    end

    context "when transfer an amount between user accounts with distinct currency" do
      context "when accounts belong to distinct issuers" do
        pending "should transfers an equivalent backup amount between issuer acounts"
        pending "should transfers an equivalent amount between users acounts"
      end
      context "when accounts belong to same issuers" do
        pending "shouldn't modify issuer backup amount"
        pending "should transfers an equivalent amount between users acounts"
      end
    end
  end

  describe "extract" do
    context "when extract an amount from a issuer backup account" do
      context "when the account has more than the needed backup amount" do
        pending "should decrements account to required amount"
      end
      context "when the account amount is less that or equal to expected backup amount" do
        pending "shouldn't allows extract required amount"
      end
    end
  end
end
