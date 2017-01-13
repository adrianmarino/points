defmodule Helper do
  def clean(value), do: value |> String.replace("\n", "") |> String.replace(" ", "") |> String.replace("\t", "")
end

defmodule Point.TransactionControllerSpec do
  use ESpec.Phoenix, controller: Point.TransactionController
  use ESpec.Phoenix.Helper
  import ServiceSpecHelper
  import Point.DecimalUtil
  alias Point.{AccountFactory, ExchangeRateService, TransactionService}

  let valid_attrs: %{
    name: "test_transfer",
    source: """
    defmodule TestTransfer do
      use Transaction
      def perform(params) do
        transfer(
          from: account(email: params.from.email, currency: params.from.currency),
          to: account(email: params.to.email, currency: params.to.currency),
          amount: params.amount
        )
      end
    end
    """
  }

  describe "perfom" do
    let! response: post(sec_conn, transaction_path(sec_conn, :execute, valid_attrs.name), params)

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
        post(
          content_type(sec_conn, text_plain),
          transaction_path(sec_conn, :create, valid_attrs.name),
          valid_attrs.source
        )
        ExchangeRateService.insert!(source_code: currency_code(source_backup),
          target_code: currency_code(source), value: Decimal.new(1))
        ExchangeRateService.insert!(source_code: currency_code(target_backup),
          target_code: currency_code(target), value: Decimal.new(2))
        ExchangeRateService.insert!(source_code: currency_code(source),
          target_code: currency_code(target), value: Decimal.new(3))

        File.rmdir(Point.Config.get(:tmp_path))
        response
      end

      it "responds 200 status", do: expect response.status |> to(eq 200)

      it "decreases source account", do: expect is(amount(source).(), less_that: source.amount) |> to(be_truthy)

      it "increases target account", do: expect is(amount(target).(), greater_that: target.amount) |> to(be_truthy)
    end
  end

  describe "create" do
    let! response: post(
      content_type(sec_conn, text_plain),
      transaction_path(sec_conn, :create, valid_attrs.name),
      valid_attrs.source
    )

    context "when create a valid transaction" do
      let db_transaction: TransactionService.by(name: valid_attrs.name)

      it "responds 201 status", do: expect response.status |> to(eq 201)

      it "save transaction to db", do: expect(db_transaction).to(be_truthy)

      it "save transaction to db with a source code" do
        expect(Helper.clean(db_transaction.source)).to(eq Helper.clean(valid_attrs.source))
      end
    end
  end
end
