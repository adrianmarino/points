defmodule Point.SessionView do
  use Point.Web, :view
  alias Point.SessionView

  def render("show.json", %{session: session}), do: render_one(session, SessionView, "session.json")
  def render("session.json", %{session: session}), do: %{token: session.token}
  def render("error.json", _anything), do: %{errors: "failed to authenticate"}
end
