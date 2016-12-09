defmodule Point.UserView do
  use Point.Web, :view
  alias Point.UserView

  def render("index.json", %{users: users}), do: render_many(users, UserView, "user.json")

  def render("show.json", %{user: user}), do: render_one(user, UserView, "user.json")

  def render("user.json", %{user: user}) do
    %{email: user.email, first_name: user.first_name, last_name: user.last_name}
  end
end
