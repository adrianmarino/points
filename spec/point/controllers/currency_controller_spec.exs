defmodule Point.CurrencyControllerTest do
  use ESpec.Phoenix, controller: Point.CurrencyController
  use ESpec.Phoenix.Helper
  alias Point.{Currency, CurrencyService, Repo, CurrencyFactory, AccountFactory}
  require Logger

  let valid_attrs: %{code: "CRR", name: "Currency", issuer_id: current_session.user_id}
  let invalid_attrs: %{code: "", name: ""}

  describe "create" do
    let response: post(sec_conn, currency_path(sec_conn, :create), currency)
    before do: response

    context "when data is valid" do
      let currency: valid_attrs
      let response_currency_code: json_response(response, 201)["code"]


      it do: expect response.status |> to(eq 201)
      it "returns the inserted currency code", do: expect response_currency_code |> to(eq currency.code)
      it "inserts the currency in database", do: expect CurrencyService.by(code: currency.code) |> to(be_truthy)
    end

    context "when data is invalid" do
      let currency: invalid_attrs
      let errors: json_response(response, 422)["errors"]

      it do: expect response.status |> to(eq 422)
      it do: expect errors |> not_to(be_empty)
    end
  end

  describe "index" do
    let response_body: json_response(response, 200)
    let response: get(sec_conn, currency_path(sec_conn, :index))

    before do: post(sec_conn, currency_path(sec_conn, :create), valid_attrs)

    it "returns a non empty collection", do: expect response_body |> not_to(be_empty)
  end

  describe "show" do
    let response: get(sec_conn, currency_path(sec_conn, :show, currency.code))

    context "when found a currency" do
      let currency: Repo.insert!(Currency.changeset(%Currency{}, valid_attrs))
      let response_body: json_response(response, 200)

      it do: expect response.status |> to(eq 200)
      it "returns account code", do: expect response_body["code"] |> to(eq currency.code)
      it "returns account name", do: expect response_body["name"] |> to(eq currency.name)
    end

    context "when not found a currency" do
      let currency: %Currency{code: "XXX"}

      it do: expect response.status |> to(eq 404)
    end
  end

  describe "update" do
    let response: put(sec_conn, currency_path(sec_conn, :update, currency.code), currency: update_attrs)

    context "when data is valid" do
      let update_attrs: valid_attrs
      let currency: Repo.insert!(Currency.changeset(%Currency{}, valid_attrs))
      let response_body: json_response(response, 200)

      it do: expect response.status |> to(eq 200)
      it "returns account code", do: expect response_body["code"] |> to(eq currency.code)
      it "returns account name", do: expect response_body["name"] |> to(eq currency.name)
    end

    context "when data is invalid" do
      let update_attrs: invalid_attrs
      let currency: Repo.insert!(Currency.changeset(%Currency{}, valid_attrs))
      let errors: json_response(response, 422)["errors"]

      it do: expect response.status |> to(eq 422)
      it do: expect errors |> not_to(be_empty)
    end
  end

  describe "delete" do
    let response: delete(sec_conn, currency_path(sec_conn, :update, currency.code))
    before do: response

    context "when delete an unused currency" do
      let currency: Repo.insert!(Currency.changeset(%Currency{}, valid_attrs))

      it do: expect response.status |> to(eq 204)
      it do: expect CurrencyService.by(code: currency.code) |> to(be_falsy)
    end

    context "when delete an used currency" do
      let account: AccountFactory.insert(:universe_backup)
      let currency: Repo.assoc(account, :currency)

      it do: expect response.status |> to(eq 404)
      it do: expect CurrencyService.by(code: currency.code) |> to(be_truthy)
    end

    context "when currency non exist" do
      let currency: invalid_attrs

      it do: expect response.status |> to(eq 404)
    end
  end
end
