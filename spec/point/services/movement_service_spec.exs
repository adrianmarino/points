defmodule Point.Services.MovementServiceSpec do
  use ESpec
  alias Point.AccountFactory
  import Point.Repo
  import Decimal
  import Point.AccountService

  let amount: new 100.1234567891

  describe "deposit" do
    let deposit: ok_result(described_module.deposit(amount: amount, on: account))

    context "when deposit an amount to issuer backup account" do
      let account: AccountFactory.insert(:revel_backup)
      before do: deposit

      it "should increase account balance for deposited amount" do
        expect(refresh(account).amount).to(eq add(account.amount, amount))
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

  describe "transfer" do
    let transfer: ok_result(described_module.transfer(from: source, to: target, amount: amount))

    context "when transfer an amount between user accounts with same currency" do
      context "when accounts belong to same issuers" do
        let backup: AccountFactory.insert(:revel_backup)
        let source: AccountFactory.insert(:obiwan_kenoby_revel, issuer: backup.owner)
        let target: AccountFactory.insert(:han_solo_revel, issuer: backup.owner)

        it "should increase target account balance to transfered amount" do
          expect fn-> transfer end |> to(change fn-> refresh(target).amount end, add(target.amount, amount))
        end

        it "should decrease source account balance to transfered amount" do
          expect fn-> transfer end |> to(change fn-> refresh(source).amount end, sub(source.amount, amount))
        end

        it "creates a movement with an expected target account" do
          expect(assoc(transfer, :target).id).to(eq target.id)
        end

        it "creates a movement with an expected source account" do
          expect(assoc(transfer, :source).id).to(eq source.id)
        end

        it "creates a movement with trasfered amount", do: expect(transfer.amount).to(eq amount)

        it "shouldn't modifies issuer account amount" do
          expect fn-> transfer end |> to_not(change fn-> backup_account_of(source).amount end)
        end
      end

      context "when accounts belong to distinct issuers" do
        let source: AccountFactory.insert(:obiwan_kenoby_revel)
        let target: AccountFactory.insert(:jango_fett_empire)

        let source_backup: AccountFactory.insert(:revel_backup)
        let target_backup: AccountFactory.insert(:empire_backup)

        let rate: ExchangeRateFactory.insert(:revel_empire_point)

        it "should increase target account balance to transfered amount" do
        end

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

  defp ok_result({:ok, value } = _), do: value
end
