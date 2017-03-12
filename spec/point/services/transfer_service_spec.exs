defmodule Point.TransferServiceSpec do
  use ESpec
  import ServiceSpecHelper
  import Decimal
  alias Point.{ExchangeRate, AccountFactory, EntityFactory, EntityService}

  let amount: Decimal.new 10.12
  let transfer: described_module().transfer(from: source(), to: target(), amount: amount())

  context "when transfer amount between accounts with same currency and under same entity" do
    let backup: AccountFactory.insert(:revel_backup)
    let entity: backup().entity
    let issuer: backup().owner

    let source: AccountFactory.insert(:obiwan_kenoby, issuer: issuer(), entity: entity())
    let target: AccountFactory.insert(:han_solo, issuer: issuer(), entity: entity(),
      currency: source().currency)

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

    it "shouldn't modifies issuer account amount" do
      expect fn-> transfer() end |> to_not(change backup_amount(source()))
    end
  end

  context "when transfer money between accounts under same currency that belong to distinct \
          entities and have backup accounts under same currency" do
    let source_backup: AccountFactory.insert(:revel_backup)
    let target_backup: AccountFactory.insert(:empire_backup, currency: source_backup().currency)

    let source: AccountFactory.insert(:han_solo,
      issuer: source_backup().owner, entity: source_backup().entity)
    let target: AccountFactory.insert(:jango_fett,
      issuer: target_backup().owner, entity: target_backup().entity, currency: source().currency)

    let backup_default_rate: rate(source_backup(), source(), 10)
    let default_backup_rate: ExchangeRate.inverse(backup_default_rate())

    let transfered_backup_amount: mult(amount(), default_backup_rate())

    before do
      backup_default_rate
      EntityService.associate(source_backup().entity, target_backup().entity)
    end

    it "should creates an transfer movement", do: expect(transfer().type).to(eq "transfer")

    it "should decreases source account to transfered amount" do
      expect fn-> transfer() end |> to(change amount(source()), minus(source(), amount()))
    end

    it "should increases target account to transfered amount" do
      expect fn-> transfer() end |> to(change amount(target()), plus(target(), amount()))
    end

    it "should decreases source backup account to transfered amount" do
      final_amount = round(sub(target_backup().amount, transfered_backup_amount()), 2)

      expect fn-> transfer() end |> to(change amount(source_backup()), final_amount)
    end

    it "should increases target backup account to transfered amount" do
      final_amount = round(add(target_backup().amount, transfered_backup_amount()), 2)

      expect fn-> transfer() end |> to(change amount(target_backup()), final_amount)
    end
  end

  context "when transfer amount between accounts with distinct currency and under same entity" do
    let backup: AccountFactory.insert(:revel_backup)
    let entity: backup().entity
    let issuer: backup().owner

    let source: AccountFactory.insert(:han_solo, issuer: issuer(), entity: entity())
    let target: AccountFactory.insert(:jango_fett, issuer: issuer(), entity: entity())

    let source_target_rate: rate(source(), target(), 2).value

    before do
      rate(backup(), source(), 5)
      source_target_rate()
    end

    it "should creates an transfer movement", do: expect(transfer().type).to(eq "transfer")

    it "should decreases source account to transfered amount" do
      expect fn-> transfer() end |> to(change amount(source()), minus(source(), amount()))
    end

    it "should increases target account to transfered amount" do
      final_amount = round(add(target().amount, mult(amount(), source_target_rate())), 2)

      expect fn-> transfer() end |> to(change amount(target()), final_amount)
    end

    it "shouldn't modifies issuer account amount" do
      expect fn-> transfer() end |> to_not(change backup_amount(source()))
    end
  end

  context "when transfer amount between accounts with distinct currency and entities" do
    let source_backup: AccountFactory.insert(:revel_backup)
    let target_backup: AccountFactory.insert(:empire_backup)

    let source_entity: source_backup().entity
    let target_entity: target_backup().entity

    let source: AccountFactory.insert(:han_solo, issuer: source_backup().owner, entity: source_entity())
    let target: AccountFactory.insert(:jango_fett, issuer: target_backup().owner, entity: target_entity())

    let source_backup_source_rate: rate(source_backup(), source(), 5)
    let source_source_backup_rate: ExchangeRate.inverse(source_backup_source_rate())

    let issuer_issuer_rate: rate(source_backup(), target_backup(), 10)
    let source_target_rate: rate(source(), target(), 2)

    before do
      source_source_backup_rate()
      issuer_issuer_rate()
      source_target_rate()
      EntityService.associate(source_entity(), target_entity())
    end

    it "should creates an transfer movement", do: expect(transfer().type).to(eq "transfer")

    it "should decreases source account to transfered amount" do
      expect fn-> transfer() end |> to(change amount(source()), minus(source(), amount()))
    end

    it "should increases target account to transfered amount" do
      rate = new(source_target_rate().value)
      final_amount = round(add(target().amount, mult(amount(), rate)), 2)

      expect fn-> transfer() end |> to(change amount(target()), final_amount)
    end

    it "should decreases source backup account to transfered amount()" do
      final_amount = round(sub(source_backup().amount, mult(amount(), source_source_backup_rate)), 2)

      expect fn-> transfer() end |> to(change amount(source_backup()), final_amount)
    end

    it "should increases target backup account to transfered amount" do
      transfer_amount = mult(amount(), source_source_backup_rate)
      final_amount = round(add(target_backup().amount, mult(transfer_amount, new(issuer_issuer_rate().value))), 2)

      expect fn-> transfer() end |> to(change amount(target_backup()), final_amount)
    end
  end

  context "when transfer money between accounts under entities that aren't partners" do
    let source: AccountFactory.insert(:han_solo, entity: EntityFactory.insert(:rebelion))
    let target: AccountFactory.insert(:jango_fett, entity: EntityFactory.insert(:empire))

    it "should be disalowed", do: expect fn-> transfer() end |> to(raise_exception())
  end
end
