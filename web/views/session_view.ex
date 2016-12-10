defmodule Point.SessionView do
  use Point.Web, :view
  alias Point.SessionView

  def render("index.json", %{sessions: sessions}), do: render_many(sessions, SessionView, "email_timeout.json")
  def render("email_timeout.json", %{session: session}) do
    %{email: session.email, timeout: Point.TimeUtil.sec_humanized(session.seconds_left)}
  end
  def render("show.json", %{session: session}), do: render_one(session, SessionView, "session.json")
  def render("session.json", %{session: session}), do: %{token: session.token}
  def render("error.json", _anything), do: %{errors: "failed to authenticate"}
end
