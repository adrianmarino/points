defmodule Point.PartnerControllerSpec do
  use ESpec.Phoenix, controller: Point.PartnerController
  use ESpec.Phoenix.Helper
  alias Point.{EntityFactory, PartnerService}

  describe "create" do
    let entity: EntityFactory.insert(:rebelion)
    let partner: EntityFactory.insert(:empire)
    let response: post(sec_conn(), entity_partner_path(sec_conn(), :create, entity().code), code: partner().code)
    let db_partner: PartnerService.by(entity: entity(), partner: partner())
    let response_body: json_response(response(), 201)

    before do: response()

    it "returns created status", do: expect response().status |> to(eq 201)
    it "returns partner code", do: expect response_body()["code"] |> to(eq partner().code)
    it "returns entity code", do: expect response_body()["entity_code"] |> to(eq entity().code)
    it "creates partner assoc in database", do: expect db_partner() |> not_to(eq nil)
    it "creates partner assoc in database to the entity", do: expect db_partner().entity_id |> to(eq entity().id)
    it "creates partner assoc in database with a partner", do: expect db_partner().partner_id |> to(eq partner().id)
  end

  describe "index" do
    let entity: EntityFactory.insert(:rebelion)
    let partner: EntityFactory.insert(:empire)
    let response: get(sec_conn(), entity_partner_path(sec_conn(), :index, entity().code))
    let partners: json_response(response(), 200)
    let first_partner: List.first(partners())

    before do
      PartnerService.insert!(entity(), partner())
      response()
    end

    it "returns created status", do: expect response().status |> to(eq 200)
    it "returns partner code", do: expect first_partner()["code"] |> to(eq partner().code)
    it "returns entity code", do: expect first_partner()["entity_code"] |> to(eq entity().code)
  end

  describe "delete" do
    let response: delete(sec_conn(), entity_partner_path(sec_conn(), :delete, entity().code, partner().code))

    context "when there is an entity partner" do
      let entity: EntityFactory.insert(:rebelion)
      let partner: EntityFactory.insert(:empire)
      let db_partner: PartnerService.by(code: partner().code, entity_code: entity().code)

      before do
        PartnerService.insert!(entity(), partner())
        response()
      end

      it "returns deleted status", do: expect response().status |> to(eq 204)
      it "deletes partner on datanase", do: expect db_partner() |> to(eq nil)
    end

    context "when there aren't partners" do
      let entity: EntityFactory.insert(:rebelion)
      let partner: EntityFactory.insert(:empire)

      before do: response()

      it "returns not found status", do: expect response().status |> to(eq 404)
    end
  end
end
