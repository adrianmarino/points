defmodule Point.UserView do
  use Point.Web, :view

  def render("index.json", %{users: users}), do: render_many(users, Point.UserView, "user.json")

  def render("show.json", %{user: user}), do: render_one(user, Point.UserView, "user.json")

  def render("user.json", %{user: user}) do
    %{id: user.id, first_name: user.first_name, last_name: user.last_name,
      email: user.email, password: user.password }
  end
end
