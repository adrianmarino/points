defmodule Point.ExchangeRateControllerSpec do
  use ESpec.Phoenix, controller: Point.ExchangeRateController
  use ESpec.Phoenix.Helper
  alias Point.{ExchangeRateService, CurrencyFactory, Repo, DecimalUtil}

  let source: CurrencyFactory.insert(:ars)
  let target: CurrencyFactory.insert(:rebel_point)
  let valid_attrs: %{value: "100.00", source: source.code, target: target.code}

  describe "create" do
    let response: post(sec_conn, exchange_rate_path(sec_conn, :create), exchange_rate)
    before do: response

    context "when has valid data" do
      let exchange_rate: valid_attrs
      let response_body: json_response(response, 201)

      it do: expect response.status |> to(eq 201)

      it "returns inserted exchange rate with same value" do
        expect response_body["value"] |> to(eq to_string exchange_rate.value)
      end

      it "returns inserted exchange rate source", do: expect response_body["source"] |> to(eq source.code)
      it "returns inserted exchange rate target", do: expect response_body["target"] |> to(eq target.code)
      it "inserts exchange rate in database" do
        expect ExchangeRateService.by(source_code: source.code, target_code: target.code) |> to(be_truthy)
      end
    end

    context "when has invalid data" do
      let exchange_rate: %{valid_attrs | value: "" }
      it do: expect response.status |> to(eq 422)
    end
  end

  describe "update" do
    let response: put(sec_conn,
                      exchange_rate_path(sec_conn, :update, exchange_rate.source, exchange_rate.target),
                      exchange_rate)
    let :db_rate_value do
      case ExchangeRateService.by(source_code: exchange_rate.source, target_code: exchange_rate.target) do
        {:ok, model } -> DecimalUtil.to_string(model.value)
      end
    end

    before do
      post(sec_conn, exchange_rate_path(sec_conn, :create), valid_attrs)
      response
    end

    context "when has valid data" do
      let exchange_rate: %{valid_attrs | value: "10000.00" }
      let response_body: json_response(response, 201)

      it do: expect response.status |> to(eq 201)

      it "returns exchange rate with then updated value" do
        expect response_body["value"] |> to(eq to_string exchange_rate.value)
      end

      it "updates exchange rate value in database", do: expect db_rate_value |> to(eq exchange_rate.value)
    end

    context "when has invalid data" do
      let exchange_rate: %{valid_attrs | value: "" }

      it do: expect response.status |> to(eq 422)
      it "doesn't updates exchange rate value in database", do: expect db_rate_value |> to(eq valid_attrs.value)
    end
  end

  describe "delete" do
    let response: delete(
      sec_conn,
      exchange_rate_path(sec_conn, :delete, valid_attrs.source, valid_attrs.target)
    )

    context "when does exist exchange rate thant anyone use" do
      before do: post(sec_conn, exchange_rate_path(sec_conn, :create), valid_attrs)
      it do: expect response.status |> to(eq 204)
    end

    it "returns 404 error when doesn't exist exchange rate", do: expect response.status |> to(eq 404)
  end
end
