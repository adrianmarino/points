Code.compiler_options(ignore_module_conflict: true)

defmodule Point.TransactionControllerSpec do
  use ESpec.Phoenix, controller: Point.TransactionController
  use ESpec.Phoenix.Helper
  import ServiceSpecHelper
  import Point.DecimalUtil
  alias Point.{AccountFactory, Transaction}
  import String, only: [replace: 3]

  @transfer_path "./lib/point/transaction/default/transfer.ex"

  def clean(value), do: value |> replace("\n", "")

  let valid_attrs: %{name: "test_transfer", source: File.read!(@transfer_path) |> replace("Transfer", "TestTransfer")}
  let invalid_attrs: %{name: "any", source: ""}

  describe "index" do
    let response: get(sec_conn, transaction_path(sec_conn, :index))
    before do: post(content_type(sec_conn, text_plain), transaction_path(sec_conn, :create, valid_attrs.name),
      valid_attrs.source)

    it "returns transactions", do: expect json_response(response, 200) |> not_to(be_empty)
  end

  describe "show" do
    let response: get(sec_conn, transaction_path(sec_conn, :show, valid_attrs.name))

    context "when found a transaction" do
      before do: post(content_type(sec_conn, text_plain), transaction_path(sec_conn, :create, valid_attrs.name),
        valid_attrs.source)
      let response_body: json_response(response, 200)

      it "returns ok status", do: expect response.status |> to(eq 200)
      it "returns account name", do: expect response_body["name"] |> to(eq valid_attrs.name)
      it "returns account source", do: expect clean(response_body["source"]) |> to(eq clean(valid_attrs.source))
    end

    it "returns not found status when non-exist a transaction", do: expect response.status |> to(eq 404)
  end

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

      it "returns ok status", do: expect response.status |> to(eq 200)
      it "decreases source account", do: expect is(amount(source).(), less_that: source.amount) |> to(be_truthy)
      it "increases target account", do: expect is(amount(target).(), greater_that: target.amount) |> to(be_truthy)
    end

    context "when perform a transfer with invalid param" do
      let params: %{}
      before do: post(content_type(sec_conn, text_plain), transaction_path(sec_conn, :create, valid_attrs.name),
        valid_attrs.source)
      it "returns internal server error status", do: expect response.status |> to(eq 500)
    end

    context "when not found a transaction to perform" do
      let params: %{}
      it "returns not found status", do: expect response.status |> to(eq 404)
    end
  end

  describe "create" do
    let response: post(content_type(sec_conn, text_plain), transaction_path(sec_conn, :create, attrs.name),
      attrs.source)

    context "when create a valid transaction" do
      let attrs: valid_attrs
      let response_body: json_response(response, 201)

      it "returns created status", do: expect response.status |> to(eq 201)
      it "returns account name", do: expect response_body["name"] |> to(eq attrs.name)
      it "returns account source", do: expect clean(response_body["source"]) |> to(eq clean(attrs.source))
      it "returns issuer email", do: expect clean(response_body["issuer_email"]) |> to(eq current_user.email)
    end

    context "when create an invalid transaction" do
      let attrs: invalid_attrs
      it "returns unprocessable_entity status", do: expect response.status |> to(eq 422)
    end
  end

  describe "delete" do
    let response: delete(content_type(sec_conn, text_plain), transaction_path(sec_conn, :delete, valid_attrs.name))

    context "when exist the transaction" do
      before do
        post(content_type(sec_conn, text_plain),
            transaction_path(sec_conn, :create, valid_attrs.name),
            valid_attrs.source)
        response
      end

      it "returns deleted status", do: expect response.status |> to(eq 204)
      it "removes transaction from database" do
        expect Repo.get_by(Transaction, name: valid_attrs.name) |> to(eq nil)
      end
    end

    it "returns not found status when non-exist the transaction", do: expect response.status |> to(eq 404)
  end

  describe "update" do
    let response: put(content_type(sec_conn, text_plain), transaction_path(sec_conn, :update, attrs.name),
      attrs.source)

    context "when update a transaction with a valid source" do
      let attrs: %{valid_attrs | source: "defmodule TestTransfer do end"}
      let response_body: json_response(response, 200)

      before do: post(content_type(sec_conn, text_plain), transaction_path(sec_conn, :create, valid_attrs.name),
        valid_attrs.source)

      it "returns ok status", do: expect response.status |> to(eq 200)
      it "returns account name", do: expect response_body["name"] |> to(eq attrs.name)
      it "returns account source", do: expect clean(response_body["source"]) |> to(eq clean(attrs.source))
      it "returns issuer email", do: expect clean(response_body["issuer_email"]) |> to(eq current_user.email)
    end

    context "when update a transaction with an invalid source" do
      let attrs: %{valid_attrs | source: ""}
      before do: post(content_type(sec_conn, text_plain), transaction_path(sec_conn, :create, valid_attrs.name),
        valid_attrs.source)

      it "returns unprocessable_entity status", do: expect response.status |> to(eq 422)
      it "returns errors description", do: expect json_response(response, 422)["errors"] |> not_to(be_empty)
    end

    context "when try to update a non-existent transaction" do
      let attrs: invalid_attrs
      it "returns not found status", do: expect response.status |> to(eq 400)
    end
  end
end
