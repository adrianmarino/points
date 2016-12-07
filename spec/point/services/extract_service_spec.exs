defmodule Point.ExtractServiceSpec do
  use ESpec
  import ServiceSpecHelper
  import Point.Repo
  import Decimal
  alias Point.{ExchangeRate, AccountFactory}

  let backup: AccountFactory.insert(:revel_backup)
  let account: AccountFactory.insert(:han_solo_revel, issuer: backup.owner)
  let issuer_owner_rate: %ExchangeRate{value: 5, source: backup.currency, target: account.currency}
  let extract: ok_result(described_module.extract(amount: amount, from: backup))

  before do: insert!(issuer_owner_rate)

  context "when extract an amount from backup account that has more than needed backup" do
    let amount: Decimal.new 10.12

    it "should decrements backup account to required amount" do
      expect fn-> extract end |> to(change amount(backup), minus(backup, amount))
    end
  end

  context "when extract an amount from backup account that has less than needed backup" do
    let amount: Decimal.new 15000

    it "shouldn't allows extract required amount", do: expect fn-> extract end |> to(raise_exception)
  end
end
