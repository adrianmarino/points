defmodule Helper do
  import String
  def clean(value), do: value |> replace("\n", "") |> replace(" ", "")
end

defmodule Point.TransactionControllerSpec do
  use ESpec.Phoenix, controller: Point.TransactionController
  use ESpec.Phoenix.Helper
  import ServiceSpecHelper
  import Point.DecimalUtil
  alias Point.{AccountFactory, TransactionService}
  import Helper

  let valid_attrs: %{
    name: "test_transfer",
    source: """
    defmodule TestTransfer do
      use Transaction

      defparams do
        acc_def = %{email: :required, currency: :required}
        %{from: acc_def, to: acc_def, amount: :required}
      end

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

  let invalid_attrs: %{ name: "any", source: ""}

  describe "perfom" do
    let! response: post(sec_conn, transaction_path(sec_conn, :execute, valid_attrs.name), params)

    context "when perform a transfer with valid param" do
      let params: %{
        "from" => %{"email" => owner_email(source), "currency" => currency_code(source) },
        "to" =>  %{"email" => owner_email(target), "currency" => currency_code(target) },
        "amount" => 100
      }

      let source_backup: AccountFactory.insert(:revel_backup)
      let target_backup: AccountFactory.insert(:empire_backup)
      let source: AccountFactory.insert(:obiwan_kenoby_revel, issuer: source_backup.owner)
      let target: AccountFactory.insert(:jango_fett_empire, issuer: target_backup.owner)

      before do
        rate(source_backup, source, 1)
        rate(target_backup, target, 2)
        rate(source, target, 3)

        post(content_type(sec_conn, text_plain), transaction_path(sec_conn, :create, valid_attrs.name),
          valid_attrs.source)
        response
      end

      it "responds 200 status", do: expect response.status |> to(eq 200)

      it "decreases source account", do: expect is(amount(source).(), less_that: source.amount) |> to(be_truthy)

      it "increases target account", do: expect is(amount(target).(), greater_that: target.amount) |> to(be_truthy)
    end

    context "when perform a transfer with invalid param" do
      let params: %{}
      before do
        post(content_type(sec_conn, text_plain), transaction_path(sec_conn, :create, valid_attrs.name),
          valid_attrs.source)
      end

      it "responds an internal sever error", do: expect response.status |> to(eq 500)
    end

    context "when not found a transaction to perform" do
      let params: %{}
      it "responds not found", do: expect response.status |> to(eq 404)
    end
  end

  describe "create" do
    let :response do
      post(content_type(sec_conn, text_plain), transaction_path(sec_conn, :create, attrs.name), attrs.source)
    end

    context "when create a valid transaction" do
      let attrs: valid_attrs
      let db_transaction: TransactionService.by(name: attrs.name)
      before do: response

      it "responds 201 status", do: expect response.status |> to(eq 201)

      it "save transaction to db", do: expect db_transaction |> to(be_truthy)

      it "save transaction to db with a source code" do
        expect clean(db_transaction.source) |> to(eq clean(attrs.source))
      end
    end

    context "when create an invalid transaction" do
      let attrs: invalid_attrs
      it "responds 422 status", do: expect response.status |> to(eq 422)
    end
  end

  describe "delete" do
    let response: delete(content_type(sec_conn, text_plain), transaction_path(sec_conn, :delete, valid_attrs.name))

    context "when the transaction exist" do
      before do
        post(content_type(sec_conn, text_plain), transaction_path(sec_conn, :create, valid_attrs.name),
          valid_attrs.source)
      end
      it "responds 204 status", do: expect response.status |> to(eq 204)
    end

    it "responds 404 status when not found the transaction", do: expect response.status |> to(eq 404)
  end

  describe "update" do
    let :response do
      put(content_type(sec_conn, text_plain), transaction_path(sec_conn, :update, attrs.name), attrs.source)
    end

    context "when update transaction with a valid source code" do
      let attrs: %{
        valid_attrs |
        source: """
        defmodule TestTransfer do
        end
        """
      }
      let response_body: json_response(response, 200)
      let db_transaction: TransactionService.by(name: attrs.name)
      before do
        post(content_type(sec_conn, text_plain), transaction_path(sec_conn, :create, valid_attrs.name),
            valid_attrs.source)
        response
      end

      it do: expect response.status |> to(eq 200)

      it "save transaction to db with a source code" do
        expect clean(db_transaction.source) |> to(eq clean(attrs.source))
      end
    end

    context "when update transaction with an invalid source code" do
      let attrs: %{valid_attrs | source: ""}
      before do
        post(content_type(sec_conn, text_plain), transaction_path(sec_conn, :create, valid_attrs.name),
            valid_attrs.source)
      end

      it do: expect response.status |> to(eq 422)
      it do: expect json_response(response, 422)["errors"] |> not_to(be_empty)
    end

    context "when not found the transaction" do
      let attrs: invalid_attrs
      it "responds 400 status", do: expect response.status |> to(eq 400)
    end
  end
end
