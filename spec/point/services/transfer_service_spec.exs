defmodule Point.TransferServiceSpec do
  use ESpec
  alias Point.AccountFactory
  import ServiceSpecHelper
  import Point.Repo
  import Decimal

  let amount: new 100.1234567891

  describe "transfer" do
    let transfer: ok_result(described_module.transfer(from: source, to: target, amount: amount))

    context "when transfer amount between accounts with same currency and issuer" do
      let backup: AccountFactory.insert(:revel_backup)
      let source: AccountFactory.insert(:obiwan_kenoby_revel, issuer: backup.owner)
      let target: AccountFactory.insert(:han_solo_revel, issuer: backup.owner)

      it "should increases target account balance to transfered amount" do
        expect fn-> transfer end |> to(change amount(target), plus(target, amount))
      end

      it "should decreases source account balance to transfered amount" do
        expect fn-> transfer end |> to(change amount(source), minus(source, amount))
      end

      it "creates a movement with an expected target account" do
        expect(assoc(transfer, :target).id).to(eq target.id)
      end

      it "creates a movement with an expected source account" do
        expect(assoc(transfer, :source).id).to(eq source.id)
      end

      it "creates a movement with trasfered amount", do: expect(transfer.amount).to(eq amount)

      it "shouldn't modifies issuer account amount" do
        expect fn-> transfer end |> to_not(change backup_amount(source))
      end
    end

    context "when transfer amount between accounts with same currency and distinct issuer" do
      let source_backup: AccountFactory.insert(:revel_backup)
      let target_backup: AccountFactory.insert(:empire_backup)

      let source: AccountFactory.insert(:han_solo_revel_shared, issuer: source_backup.owner)
      let target: AccountFactory.insert(:jango_fett_empire_shared, issuer: target_backup.owner)

      let rate: ExchangeRateFactory.insert(:shared_point_ars_point)

      it "should increases target account balance to transfered amount" do
        expect fn-> transfer end |> to(change amount(target), plus(target, amount))
      end

      it "should decreases source account balance in transfered amount" do
        expect fn-> transfer end |> to(change amount(source), minus(source, amount))
      end

      xit "should increases target backup account to transfered amount in target currency" do
        expect fn-> transfer end |> to(change amount(target_backup), plus(target_backup, amount))
      end

      xit "should decreases target backup account to transfered amount in target currency" do
        expect fn-> transfer end |> to(change amount(source_backup), minus(source_backup, amount))
      end

      pending "should transfers an equivalent backup amount between issuer acounts"
      pending "should transfers amount between user acounts"
    end
  end

  context "when transfer an amount between accounts with distinct currency and same issuer" do
  end

  context "when transfer an amount between accounts with distinct currency and issuer" do
  end
end
