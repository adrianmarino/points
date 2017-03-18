defmodule Point.ExtractServiceSpec do
  use ESpec
  import ServiceSpecHelper
  alias Point.Repo
  alias Point.{ExchangeRate, AccountFactory}

  let backup: AccountFactory.insert(:revel_backup)
  let account: AccountFactory.insert(:han_solo, issuer: backup().owner)
  let issuer_owner_rate: %ExchangeRate{value: 5, source: backup().currency, target: account().currency}
  let extract: described_module().extract(amount: amount(), from: backup())

  before do: Repo.insert!(issuer_owner_rate())

  context "when extract an amount from backup account that has more than needed backup" do
    let amount: Decimal.new 10.12

    it "should decrements backup account to required amount" do
      expect fn-> extract() end |> to(change amount(backup()), minus(backup(), amount()))
    end

    it "should creates an extract movement", do: expect(extract().type).to(eq "extract")
  end

  context "when extract an amount from backup account that has less than needed backup" do
    let amount: Decimal.new 15000

    it "shouldn't allows extract required amount", do: expect fn-> extract() end |> to(raise_exception())
  end
end
