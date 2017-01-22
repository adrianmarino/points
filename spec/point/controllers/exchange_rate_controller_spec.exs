defmodule Point.ExchangeRateControllerSpec do
  use ESpec.Phoenix, controller: Point.ExchangeRateController
  use ESpec.Phoenix.Helper
  alias Point.{ExchangeRateService, CurrencyFactory, Repo}

  let source: CurrencyFactory.insert(:ars)
  let target: CurrencyFactory.insert(:rebel_point)
  let valid_attrs: %{value: "100.00", source: source.code, target: target.code}

  describe "index" do
    it "returns exchange rates"
  end

  describe "show" do
    context "when found an exchange rate" do
      it "returns ok status"
      it "returns a source currency code"
      it "returns a target currency code"
    end

    context "when not found an exchange rate" do
      it "returns not found status"
    end
  end

  describe "create" do
    let response: post(sec_conn, exchange_rate_path(sec_conn, :create), attrs)

    context "when has valid data" do
      let attrs: valid_attrs
      let response_body: json_response(response, 201)
      before do: response

      it "returns created status", do: expect response.status |> to(eq 201)

      it "returns inserted exchange rate with same value" do
        expect response_body["value"] |> to(eq to_string attrs.value)
      end

      it "returns inserted exchange rate source", do: expect response_body["source"] |> to(eq attrs.source)
      it "returns inserted exchange rate target", do: expect response_body["target"] |> to(eq attrs.target)
      it "inserts exchange rate in database" do
        expect ExchangeRateService.by(source_code: attrs.source, target_code: attrs.target) |> to(be_truthy)
      end
    end

    context "when has invalid data" do
      let attrs: %{valid_attrs | value: ""}
      it "returns unprocessable_entity status", do: expect response.status |> to(eq 422)
    end
  end

  describe "update" do
    let response: put(sec_conn, exchange_rate_path(sec_conn, :update, attrs.source, attrs.target), attrs)
    let db_rate_value: ExchangeRateService.by!(source_code: attrs.source, target_code: attrs.target)

    before do
      post(sec_conn, exchange_rate_path(sec_conn, :create), valid_attrs)
      response
    end

    context "when has valid data" do
      let attrs: %{valid_attrs | value: "10000.00" }

      it "returns created status", do: expect response.status |> to(eq 201)
      it "returns exchange rate with then updated value" do
        expect json_response(response, 201)["value"] |> to(eq to_string attrs.value)
      end
      it "updates exchange rate value in database", do: expect db_rate_value |> to(eq attrs.value)
    end

    context "when has invalid data" do
      let attrs: %{valid_attrs | value: ""}

      it "returns unprocessable_entity status", do: expect response.status |> to(eq 422)
      it "doesn't updates exchange rate value in database", do: expect db_rate_value |> to(eq valid_attrs.value)
    end
  end

  describe "delete" do
    let response: delete(sec_conn, exchange_rate_path(sec_conn, :delete, valid_attrs.source, valid_attrs.target))

    context "when does exist exchange rate that anyone use" do
      before do: post(sec_conn, exchange_rate_path(sec_conn, :create), valid_attrs)
      it "returns deleted status", do: expect response.status |> to(eq 204)
    end

    it "returns not found status when doesn't exist exchange rate", do: expect response.status |> to(eq 404)
  end
end
