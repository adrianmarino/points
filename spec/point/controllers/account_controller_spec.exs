defmodule Point.AccountControllerSpec do
  use ESpec.Phoenix, controller: Point.AccountController
  use ESpec.Phoenix.Helper
  alias Point.{Repo, AccountFactory, Account, UserFactory, CurrencyFactory, AccountService, DecimalUtil}

  context "when request all accounts" do
    let response: get(sec_conn, account_path(sec_conn, :index))
    let body: json_response(response, 200)

    it "returns 201 status", do: expect(response.status).to(eq 200)

    it "has a body", do: expect(body).to(be_empty)
  end

  context "when request a default account" do
    let account: AccountFactory.insert(:revel_backup)
    let response: get(sec_conn, account_path(sec_conn, :show, account))
    let body: json_response(response, 200)

    it "returns 201 status", do: expect(response.status).to(eq 200)

    it "returns account id", do: expect body["id"] |> to(eq account.id)

    it "returns account type", do: expect body["type"] |> to(eq account.type)

    it "returns account amount", do: expect body["amount"] |> to(eq DecimalUtil.to_string(account.amount))

    it "returns account currency code", do: expect body["currency"] |> to(eq Repo.assoc(account, :currency).code)

    it "returns account owner email", do: expect body["owner_email"] |> to(eq Repo.assoc(account, :owner).email)

    it "returns account issuer email", do: expect body["issuer_email"] |> to(eq Repo.assoc(account, :issuer).email)
  end

  context "when request a backup account" do
    let account: AccountFactory.insert(:universe_backup)
    let response: get(sec_conn, account_path(sec_conn, :show, account))
    let body: json_response(response, 200)

    it "returns 201 status", do: expect(response.status).to(eq 200)

    it "returns an account without issuer email", do: expect body["issuer_email"] |> to(eq nil)
  end

  context "when creates an account" do
    let response: post(sec_conn, account_path(sec_conn, :create), attrs)

    context "when data is valid" do
      let owner: UserFactory.insert(:luke_skywalker)
      let currency: CurrencyFactory.insert(:ars)
      let attrs: %{type: "dafault", currency_code: currency.code, amount: Decimal.new(1000), owner_email: owner.email}
      let body: json_response(response, 201)

      it "returns 201 status", do: expect(response.status).to(eq 201)

      it "returns an account id", do: expect body["id"] |> to(be_truthy)

      it "returns an account id that exist on database", do: expect AccountService.get!(body["id"]) |> to(be_truthy)

      it "returns an account type", do: expect body["type"] |> to(eq attrs.type)

      it "returns an account amount", do: expect body["amount"] |> to(eq DecimalUtil.to_string(attrs.amount))

      it "returns an account currency code", do: expect body["currency"] |> to(eq attrs.currency_code)

      it "returns an account owner email", do: expect body["owner_email"] |> to(eq attrs.owner_email)

      it "returns an account issuer email",do: expect body["issuer_email"] |> to(eq current_user(response).email)
    end

    context "when data is invalid" do
      let attrs: %{}
      let body: json_response(response, 422)

      it "returns 422 status", do: expect(response.status).to(eq 422)
      it "returns errors description", do: expect body["errors"] |> not_to(eq %{})
    end
  end

  context "when updates an account" do
    let account: AccountFactory.insert(:revel_backup)
    let response: put(sec_conn, account_path(sec_conn, :update, account), account: attrs)

    context "and data is valid" do
      let owner: UserFactory.insert(:luke_skywalker)
      let currency: CurrencyFactory.insert(:ars)
      let attrs: %{currency_code: currency.code, amount: Decimal.new(20), owner_email: owner.email}
      let body: json_response(response, 200)

      it "returns 200 status", do: expect(response.status).to(eq 200)

      it "has same id", do: expect body["id"] |> to(eq account.id)

      it "has same type", do: expect body["type"] |> to(eq account.type)

      it "has another amount", do: expect body["amount"] |> to(eq DecimalUtil.to_string(attrs.amount))

      it "has another currency code", do: expect body["currency"] |> to(eq attrs.currency_code)

      it "has another owner email", do: expect body["owner_email"] |> to(eq attrs.owner_email)

      it "has same issuer email",do: expect body["issuer_email"] |> to(eq current_user(response).email)
    end

    context "and data is invalid" do
      let attrs: %{currency_code: "ANY", owner_email: "any"}
      let body: json_response(response, 422)

      it "returns 422 status", do: expect(response.status).to(eq 422)

      it "returns errors description", do: expect body["errors"] |> not_to(eq %{})
    end
  end

  context "when deletes chosen resource" do
    let account: Repo.insert!(%Account{})
    let response: delete(sec_conn, account_path(sec_conn, :delete, account.id))

    before do: response

    it "returns 204 status", do: expect(response.status).to(eq 204)

    it "removes account from database", do: expect Repo.get(Account, account.id) |> to(be_falsy)
  end
end
