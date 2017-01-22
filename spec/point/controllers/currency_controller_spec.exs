defmodule Point.CurrencyControllerTest do
  use ESpec.Phoenix, controller: Point.CurrencyController
  use ESpec.Phoenix.Helper
  import ServiceSpecHelper
  alias Point.{Currency, CurrencyService, CurrencyFactory, AccountFactory}
  require Logger

  let valid_attrs: %{code: "CRR", name: "Currency", issuer_id: current_session.user_id}
  let invalid_attrs: %{code: "", name: ""}

  describe "create" do
    let response: post(sec_conn, currency_path(sec_conn, :create), currency)

    context "when data is valid" do
      let currency: valid_attrs
      before do: response

      it "returns created status", do: expect response.status |> to(eq 201)
      it "returns the inserted currency code", do: expect json_response(response, 201)["code"] |> to(eq currency.code)
      it "inserts the currency in database", do: expect CurrencyService.by(code: currency.code) |> to(be_truthy)
    end

    context "when data is invalid" do
      let currency: invalid_attrs
      it "returns unprocessable_entity status", do: expect(response.status).to(eq 422)
      it "returns errors description", do: expect json_response(response, 422)["errors"] |> not_to(be_empty)
    end
  end

  describe "index" do
    let response: get(sec_conn, currency_path(sec_conn, :index))
    before do: post(sec_conn, currency_path(sec_conn, :create), valid_attrs)

    it "returns currencies", do: expect json_response(response, 200) |> not_to(be_empty)
  end

  describe "show" do
    let response: get(sec_conn, currency_path(sec_conn, :show, currency.code))

    context "when found a currency" do
      let currency:  CurrencyFactory.insert(:ars)
      let response_body: json_response(response, 200)

      it "returns ok status", do: expect response.status |> to(eq 200)
      it "returns account code", do: expect response_body["code"] |> to(eq currency.code)
      it "returns account name", do: expect response_body["name"] |> to(eq currency.name)
    end

    context "when not found a currency" do
      let currency: %Currency{code: "XXX"}
      it "returns not found status", do: expect response.status |> to(eq 404)
    end
  end

  describe "update" do
    let currency: CurrencyFactory.insert(:ars)
    let response: put(sec_conn, currency_path(sec_conn, :update, currency.code), currency: attrs)

    context "when data is valid" do
      let attrs: valid_attrs
      let response_body: json_response(response, 200)

      it "returns ok status", do: expect response.status |> to(eq 200)
      it "returns account code", do: expect response_body["code"] |> to(eq attrs.code)
      it "returns account name", do: expect response_body["name"] |> to(eq attrs.name)
    end

    context "when data is invalid" do
      let attrs: invalid_attrs
      it "returns unprocessable_entity status", do: expect(response.status).to(eq 422)
      it "returns errors description", do: expect json_response(response, 422)["errors"] |> not_to(be_empty)
    end
  end

  describe "delete" do
    let response: delete(sec_conn, currency_path(sec_conn, :update, currency_code))

    context "when delete an unused currency" do
      let currency_code: CurrencyService.insert!(valid_attrs).code
      before do: response

      it "returns deleted status", do: expect response.status |> to(eq 204)
      it "removes currency from database", do: expect CurrencyService.by(code: currency_code) |> to(be_falsy)
    end

    context "when delete an used currency" do
      let currency_code: currency_code(AccountFactory.insert(:universe_backup))
      before do: response

      it "returns bad request status", do: expect response.status |> to(eq 404)
      it "doesn't remove currency from database", do: expect CurrencyService.by(code: currency_code) |> to(be_truthy)
    end

    context "when try to delete currency" do
      let currency_code: valid_attrs.code
      it "returns bad request status", do: expect response.status |> to(eq 404)
    end
  end
end
