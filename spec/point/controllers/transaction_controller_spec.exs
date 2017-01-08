defmodule Point.TransactionControllerSpec do
  use ESpec.Phoenix, controller: Point.TransactionController
  use ESpec.Phoenix.Helper
  import ServiceSpecHelper
  import Point.DecimalUtil
  alias Point.{AccountFactory, ExchangeRateService}


  describe "perfom" do
    let! response: post(sec_conn, transaction_path(sec_conn, :perform, "transfer"), params)

    context "when perform a transfer" do
      let source_backup: AccountFactory.insert(:revel_backup)
      let target_backup: AccountFactory.insert(:empire_backup)

      let source: AccountFactory.insert(:obiwan_kenoby_revel, issuer: source_backup.owner)
      let target: AccountFactory.insert(:jango_fett_empire, issuer: target_backup.owner)

      let params: %{
        "from" => %{"email" => owner_email(source), "currency" => currency_code(source) },
        "to" =>  %{"email" => owner_email(target), "currency" => currency_code(target) },
        "amount" => 100
      }

      before do
        ExchangeRateService.insert!(source_code: currency_code(source_backup),
          target_code: currency_code(source), value: Decimal.new(1))
        ExchangeRateService.insert!(source_code: currency_code(target_backup),
          target_code: currency_code(target), value: Decimal.new(2))
        ExchangeRateService.insert!(source_code: currency_code(source),
          target_code: currency_code(target), value: Decimal.new(3))
      end

      it "responds 200 status", do: expect response.status |> to(eq 200)

      it "decreases source account" do
        expect is(amount(source).(), less_that: source.amount) |> to(be_truthy)
      end

      it "increases target account" do
        expect is(amount(target).(), greater_that: target.amount) |> to(be_truthy)
      end
    end
  end
end
