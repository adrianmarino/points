defmodule Point.EntityControllerSpec do
  use ESpec.Phoenix, controller: Point.EntityController
  use ESpec.Phoenix.Helper
  import Point.MapUtil, only: [sub_map: 2]
  alias Point.{EntityService, EntityFactory}

  let valid_attrs: %{code: "platform", name: "Point Platform"}
  let invalid_attrs: %{code: "", name: ""}

  describe "create" do
    let response: post(sec_conn(), entity_path(sec_conn(), :create), attrs())

    context "when data is valid" do
      let attrs: valid_attrs()
      let response_body: json_response(response(), 201)
      before do: response()

      it "returns created status", do: expect response().status |> to(eq 201)
      it "returns the inserted entity code", do: expect response_body()["code"] |> to(eq attrs().code)
      it "returns the inserted entity name", do: expect response_body()["name"] |> to(eq attrs().name)
      it "inserts the entity in database", do: expect EntityService.by(code: attrs().code) |> to(be_truthy())
    end

    context "when data is invalid" do
      let attrs: invalid_attrs()
      let response_body: json_response(response(), 422)
      it "returns unprocessable_entity status", do: expect(response().status).to(eq 422)
      it "returns errors description", do: expect response_body()["errors"] |> not_to(be_empty())
    end
  end

  describe "update" do
    let entity: EntityFactory.insert(:rebelion)
    let response: put(sec_conn(), entity_path(sec_conn(), :update, entity().code), sub_map(attrs(), [:name]))

    context "when data is valid" do
      let attrs: valid_attrs()
      let response_body: json_response(response(), 200)

      it "returns ok status", do: expect response().status |> to(eq 200)
      it "returns entity name", do: expect response_body()["name"] |> to(eq attrs().name)
    end

    context "when data is invalid" do
      let attrs: invalid_attrs()
      let response_body: json_response(response(), 422)

      it "returns unprocessable_entity status", do: expect(response().status).to(eq 422)
      it "returns errors description", do: expect response_body()["errors"] |> not_to(be_empty())
    end
  end

  describe "delete" do
    let response: delete(sec_conn(), entity_path(sec_conn(), :delete, entity_code()))

    context "when delete an unused entity" do
      let entity_code: EntityService.insert!(valid_attrs()).code
      before do: response()

      it "returns deleted status", do: expect response().status |> to(eq 204)
      it "removes entity from database", do: expect EntityService.by(code: entity_code()) |> to(be_falsy())
    end

    context "when delete an entity with a partner" do
      let entity: EntityService.insert!(valid_attrs())
      let partner: EntityFactory.insert(:rebelion)
      let entity_code: entity().code
      before do
        EntityService.add_partner(entity(), partner())
        response()
      end
      it "returns locked status", do: expect response().status |> to(eq 423)
      it "doesn't remove entity from database", do: expect EntityService.by(code: entity_code()) |> to(be_truthy())
    end

    context "when delete an entity have users" do
      let entity_code: EntityFactory.insert(:rebelion).code
      before do: response()

      it "returns locked status", do: expect response().status |> to(eq 423)
      it "doesn't remove entity from database", do: expect EntityService.by(code: entity_code()) |> to(be_truthy())
    end

    context "when delete an entity have accounts" do
      let entity: EntityFactory.insert(:rebelion)
      let user: Enum.at(EntityService.load(entity(), :users), 0)
      let account: AccountFactory.insert(:obiwan_kenoby, issuer: user())
      let entity_code: entity().code

      before do: response()

      it "returns locked status", do: expect response().status |> to(eq 423)
      it "doesn't remove entity from database", do: expect EntityService.by(code: entity_code()) |> to(be_truthy())
    end

    context "when try to delete entity" do
      let entity_code: valid_attrs().code
      it "returns bad request status", do: expect response().status |> to(eq 404)
    end
  end

  describe "index" do
    let response: get(sec_conn(), entity_path(sec_conn(), :index))
    before do: post(sec_conn(), entity_path(sec_conn(), :create), valid_attrs())

    it "returns entities", do: expect json_response(response(), 200) |> not_to(be_empty())
  end

  describe "show" do
    let response: get(sec_conn(), entity_path(sec_conn(), :show, entity().code))

    context "when found a entity" do
      let entity: EntityFactory.insert(:rebelion)
      let response_body: json_response(response(), 200)

      it "returns ok status", do: expect response().status |> to(eq 200)
      it "returns entity code", do: expect response_body()["code"] |> to(eq entity().code)
      it "returns entity name", do: expect response_body()["name"] |> to(eq entity().name)
    end

    context "when not found a entity" do
      let entity: %{code: "xxx"}
      it "returns not found status", do: expect response().status |> to(eq 404)
    end
  end
end
