defmodule Point.EntityView do
  use Point.Web, :view
  import Point.MapUtil
  alias Point.EntityView

  def render("index.json", %{entities: entities}), do: render_many(entities, EntityView, "entity.json")
  def render("show.json", %{entity: entity}), do: render_one(entity, EntityView, "entity.json")
  def render("entity.json", %{entity: entity}), do: sub_map(entity, [:code, :name])
end
