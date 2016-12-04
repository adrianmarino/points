defmodule Point.TransferServiceSpec do
  use ESpec
  alias Point.{ExchangeRate, AccountFactory}
  import ServiceSpecHelper
  import Point.Repo
  import Decimal

  let amount: Decimal.new 10.12
  let transfer: ok_result(described_module.transfer(from: source, to: target, amount: amount))

  context "when transfer amount between accounts with same currency and backup account" do
    let backup: AccountFactory.insert(:revel_backup)

    let source: AccountFactory.insert(:obiwan_kenoby_revel, issuer: backup.owner)
    let target: AccountFactory.insert(:han_solo_revel, issuer: backup.owner, currency: source.currency)

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

    it "creates a movement with trasfered amount",
      do: expect(transfer.amount).to(eq amount)

    it "shouldn't modifies issuer account amount" do
      expect fn-> transfer end |> to_not(change backup_amount(source))
    end
  end

  context "when transfer amount between accounts with same currency and distinct issuer with same backup account currency" do
    let source_backup: AccountFactory.insert(:revel_backup)
    let source: AccountFactory.insert(:han_solo_revel, issuer: source_backup.owner)

    let target_backup: AccountFactory.insert(:empire_backup, currency: source_backup.currency)
    let target: AccountFactory.insert(:jango_fett_empire, issuer: target_backup.owner, currency: source.currency)

    let issuer_owner_rate: %ExchangeRate{value: 10, source: source_backup.currency, target: source.currency}

    before do: insert!(issuer_owner_rate)

    it "should decreases source account to transfered amount" do
      expect fn-> transfer end |> to(change amount(source), minus(source, amount))
    end

    it "should increases target account to transfered amount" do
      expect fn-> transfer end |> to(change amount(target), plus(target, amount))
    end

    it "should decreases source backup account to transfered amount" do
      rate = ExchangeRate.inverse(issuer_owner_rate)
      final_amount = round(sub(target_backup.amount, mult(amount, rate)), 2)

      expect fn-> transfer end |> to(change amount(source_backup), final_amount)
    end

    it "should increases target backup account to transfered amount" do
      rate = ExchangeRate.inverse(issuer_owner_rate)
      final_amount = round(add(target_backup.amount, mult(amount, rate)), 2)

      expect fn-> transfer end |> to(change amount(target_backup), final_amount)
    end
  end

  context "when transfer an amount between accounts with distinct currency and same issuer" do
    let backup: AccountFactory.insert(:revel_backup)
    let source: AccountFactory.insert(:han_solo_revel, issuer: backup.owner)
    let target: AccountFactory.insert(:jango_fett_empire, issuer: backup.owner)

    let issuer_owner_rate: %ExchangeRate{value: 5, source: backup.currency, target: source.currency}
    let owner_owner_rate: %ExchangeRate{value: 2, source: source.currency, target: target.currency}

    before do
      insert!(issuer_owner_rate)
      insert!(owner_owner_rate)
    end

    it "should decreases source account to transfered amount" do
      expect fn-> transfer end |> to(change amount(source), minus(source, amount))
    end

    it "should increases target account to transfered amount" do
      rate = new(owner_owner_rate.value)
      final_amount = round(add(target.amount, mult(amount, rate)), 2)

      expect fn-> transfer end |> to(change amount(target), final_amount)
    end

    it "shouldn't modifies issuer account amount" do
      expect fn-> transfer end |> to_not(change backup_amount(source))
    end
  end

  context "when transfer an amount between accounts with distinct currency and issuer" do
    let source_backup: AccountFactory.insert(:revel_backup)
    let source: AccountFactory.insert(:han_solo_revel, issuer: source_backup.owner)

    let target_backup: AccountFactory.insert(:empire_backup)
    let target: AccountFactory.insert(:jango_fett_empire, issuer: target_backup.owner)

    let issuer_owner_rate: %ExchangeRate{value: 5, source: source_backup.currency, target: source.currency}
    let issuer_issuer_rate: %ExchangeRate{value: 10, source: source_backup.currency, target: target_backup.currency}
    let owner_owner_rate: %ExchangeRate{value: 2, source: source.currency, target: target.currency}

    before do
      insert!(issuer_owner_rate)
      insert!(issuer_issuer_rate)
      insert!(owner_owner_rate)
    end

    it "should decreases source account to transfered amount" do
      expect fn-> transfer end |> to(change amount(source), minus(source, amount))
    end

    it "should increases target account to transfered amount" do
      rate = new(owner_owner_rate.value)
      final_amount = round(add(target.amount, mult(amount, rate)), 2)

      expect fn-> transfer end |> to(change amount(target), final_amount)
    end

    it "should decreases source backup account to transfered amount" do
      final_amount = round(sub(source_backup.amount, mult(amount, ExchangeRate.inverse(issuer_owner_rate))), 2)

      expect fn-> transfer end |> to(change amount(source_backup), final_amount)
    end

    it "should increases target backup account to transfered amount" do
      transfer_amount = mult(amount, ExchangeRate.inverse(issuer_owner_rate))
      final_amount = round(add(target_backup.amount, mult(transfer_amount, new(issuer_issuer_rate.value))), 2)

      expect fn-> transfer end |> to(change amount(target_backup), final_amount)
    end
  end
end
