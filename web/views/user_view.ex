defmodule Point.UserView do
  use Point.Web, :view
  import Point.MapUtil, only: [sub_map: 2]
  alias Point.UserView

  def render("index.json", %{users: users}), do: render_many(users, UserView, "user.json")

  def render("show.json", %{user: user}), do: render_one(user, UserView, "user.json")

  def render("user.json", %{user: user}), do: sub_map(user, [:email, :role, :first_name, :last_name])
end
