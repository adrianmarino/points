defmodule Point.TransactionControllerSpec do
  use ESpec.Phoenix, controller: Point.TransactionController
  use ESpec.Phoenix.Helper
  import ServiceSpecHelper
  import Point.DecimalUtil
  alias Point.{AccountFactory, TransactionService}
  import String, only: [replace: 3]

  @transfer_path "./lib/point/transaction/default/transfer.ex"

  def clean(value), do: value |> replace("\n", "")

  let valid_attrs: %{name: "test_transfer", source: File.read!(@transfer_path) |> replace("Transfer", "TestTransfer")}
  let invalid_attrs: %{name: "any", source: ""}

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
      before do: post(content_type(sec_conn, text_plain), transaction_path(sec_conn, :create, valid_attrs.name),
        valid_attrs.source)
      it "responds an internal sever error", do: expect response.status |> to(eq 500)
    end

    context "when not found a transaction to perform" do
      let params: %{}
      it "responds not found", do: expect response.status |> to(eq 404)
    end
  end

  describe "create" do
    let response: post(content_type(sec_conn, text_plain), transaction_path(sec_conn, :create, attrs.name),
      attrs.source)

    context "when create a valid transaction" do
      let attrs: valid_attrs
      let response_body: json_response(response, 201)

      it "responds 201 status", do: expect response.status |> to(eq 201)
      it "returns account name", do: expect response_body["name"] |> to(eq attrs.name)
      it "returns account source", do: expect clean(response_body["source"]) |> to(eq clean(attrs.source))
    end

    context "when create an invalid transaction" do
      let attrs: invalid_attrs
      it "responds 422 status", do: expect response.status |> to(eq 422)
    end
  end

  describe "index" do
    let response_body: json_response(response, 200)
    let response: get(sec_conn, transaction_path(sec_conn, :index))
    before do: post(content_type(sec_conn, text_plain), transaction_path(sec_conn, :create, valid_attrs.name),
      valid_attrs.source)

    it "returns a non empty collection", do: expect response_body |> not_to(be_empty)
  end

  describe "show" do
    let response: get(sec_conn, transaction_path(sec_conn, :show, valid_attrs.name))

    context "when found a transaction" do
      before do: post(content_type(sec_conn, text_plain), transaction_path(sec_conn, :create, valid_attrs.name),
        valid_attrs.source)
      let response_body: json_response(response, 200)

      it do: expect response.status |> to(eq 200)
      it "returns account name", do: expect response_body["name"] |> to(eq valid_attrs.name)
      it "returns account source", do: expect clean(response_body["source"]) |> to(eq clean(valid_attrs.source))
    end

    it "responds 404 when not found a transaction", do: expect response.status |> to(eq 404)
  end

  describe "delete" do
    let response: delete(content_type(sec_conn, text_plain), transaction_path(sec_conn, :delete, valid_attrs.name))

    context "when the transaction exist" do
      before do: post(content_type(sec_conn, text_plain), transaction_path(sec_conn, :create, valid_attrs.name),
        valid_attrs.source)
      it "responds 204 status", do: expect response.status |> to(eq 204)
    end

    it "responds 404 status when not found the transaction", do: expect response.status |> to(eq 404)
  end

  describe "update" do
    let response: put(content_type(sec_conn, text_plain), transaction_path(sec_conn, :update, attrs.name),
      attrs.source)

    context "when update transaction with a valid source code" do
      let attrs: %{valid_attrs | source: "defmodule TestTransfer do end"}
      let response_body: json_response(response, 200)
      let response_body: json_response(response, 200)

      before do: post(content_type(sec_conn, text_plain), transaction_path(sec_conn, :create, valid_attrs.name),
        valid_attrs.source)

      it do: expect response.status |> to(eq 200)
      it "returns account name", do: expect response_body["name"] |> to(eq attrs.name)
      it "returns account source", do: expect clean(response_body["source"]) |> to(eq clean(attrs.source))
    end

    context "when update transaction with an invalid source code" do
      let attrs: %{valid_attrs | source: ""}
      before do: post(content_type(sec_conn, text_plain), transaction_path(sec_conn, :create, valid_attrs.name),
        valid_attrs.source)

      it do: expect response.status |> to(eq 422)
      it do: expect json_response(response, 422)["errors"] |> not_to(be_empty)
    end

    context "when not found the transaction" do
      let attrs: invalid_attrs
      it "responds 400 status", do: expect response.status |> to(eq 400)
    end
  end
end
