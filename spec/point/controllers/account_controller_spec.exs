defmodule Point.AccountControllerSpec do
  use ESpec.Phoenix, controller: Point.AccountController
  use ESpec.Phoenix.Helper
  import ServiceSpecHelper
  alias Point.{AccountFactory, UserFactory, CurrencyFactory, AccountService, DecimalUtil}

  describe "index" do
    let response: get(sec_conn, account_path(sec_conn, :index))
    before do: AccountFactory.insert(:revel_backup)

    it "returns ok status", do: expect(response.status).to(eq 200)
    it "returns accounts", do: expect(json_response(response, 200)).not_to(be_empty)
  end

  describe "show" do
    let response: get(sec_conn, account_path(sec_conn, :show, account))
    let response_body: json_response(response, 200)

    context "when request a default account" do
      let account: AccountFactory.insert(:revel_backup)

      it "returns ok status", do: expect(response.status).to(eq 200)

      it "returns account id", do: expect response_body["id"] |> to(eq account.id)

      it "returns account type", do: expect response_body["type"] |> to(eq account.type)

      it "returns account amount", do: expect response_body["amount"] |> to(eq to_string(account.amount))

      it "returns account currency code", do: expect response_body["currency"] |> to(eq currency_code(account))

      it "returns account owner email", do: expect response_body["owner_email"] |> to(eq owner_email(account))

      it "returns account issuer email", do: expect response_body["issuer_email"] |> to(eq issuer_email(account))
    end

    context "when request a backup account" do
      let account: AccountFactory.insert(:universe_backup)

      it "returns ok status", do: expect(response.status).to(eq 200)
      it "returns an account without issuer email", do: expect response_body["issuer_email"] |> to(eq nil)
    end
  end

  describe "create" do
    let response: post(sec_conn, account_path(sec_conn, :create), attrs)

    context "when data is valid" do
      let owner: UserFactory.insert(:luke_skywalker)
      let currency: CurrencyFactory.insert(:ars)
      let attrs: %{currency_code: currency.code, owner_email: owner.email}
      let response_body: json_response(response, 201)

      it "returns created status", do: expect(response.status).to(eq 201)

      it "returns an account id", do: expect response_body["id"] |> to(be_truthy)

      it "returns an account id that exist on database" do
        expect AccountService.get!(response_body["id"]) |> to(be_truthy)
      end

      it "returns an account type", do: expect response_body["type"] |> to(eq "default")

      it "returns an account amount", do: expect response_body["amount"] |> to(eq "0.00")

      it "returns an account currency code", do: expect response_body["currency"] |> to(eq attrs.currency_code)

      it "returns an account owner email", do: expect response_body["owner_email"] |> to(eq attrs.owner_email)

      it "returns an account issuer email" do
        expect response_body["issuer_email"] |> to(eq current_user(response).email)
      end
    end

    context "when data is invalid" do
      let attrs: %{}
      it "returns unprocessable_entity status", do: expect(response.status).to(eq 422)
      it "returns errors description", do: expect json_response(response, 422)["errors"] |> not_to(eq %{})
    end
  end

  describe "delete" do
    let account: AccountFactory.insert(:revel_backup, amount: account_amount)
    let response: delete(sec_conn, account_path(sec_conn, :delete, account.id))
    before do: response

    context "when account is empty" do
      let account_amount: DecimalUtil.zero
      it "returns deleted status", do: expect(response.status).to(eq 204)
      it "removes account from database", do: expect AccountService.get(account.id) |> to(be_falsy)
    end

    context "when account has an amount" do
      let account_amount: Decimal.new(100)
      it "returns bad request status", do: expect(response.status).to(eq 404)
      it "doesn't delete account from database", do: expect AccountService.get(account.id) |> to(be_truthy)
    end
  end
end
