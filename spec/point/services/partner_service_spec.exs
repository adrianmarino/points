defmodule Point.PartnerServiceSpec do
  use ESpec
  alias Point.{EntityFactory, EntityService}

  describe "are_they_partners?" do
    let answer: described_module().are_they_partners?(entity_a(), entity_b())

    context "when both are partners to the other" do
      let entity_a: EntityFactory.insert(:rebelion)
      let entity_b: EntityFactory.insert(:empire)

      before do: EntityService.associate(entity_a(), entity_b())

      it "returns true", do: expect answer() |> to(be_truthy())
    end

    context "when only one is partners to the other" do
      let entity_a: EntityFactory.insert(:rebelion)
      let entity_b: EntityFactory.insert(:empire)

      before do: EntityService.add_partner(entity_a(), entity_b())

      it "returns false", do: expect answer() |> to(be_falsy())
    end

    context "when any is partners to the other" do
      let entity_a: EntityFactory.insert(:rebelion)
      let entity_b: EntityFactory.insert(:empire)

      it "returns false", do: expect answer() |> to(be_falsy())
    end

    context "when have ask for the same entity" do
      let entity_a: EntityFactory.insert(:rebelion)
      let entity_b: entity_a()

      it "returns true", do: expect answer() |> to(be_truthy())
    end
  end
end
