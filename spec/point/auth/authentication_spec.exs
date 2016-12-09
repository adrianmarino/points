defmodule Point.AuthenticationSpec do
  use ESpec.Phoenix, controller: Point.Authentication
  alias Point.{Authentication, User, Session}
  import Point.Repo

  let opts: Authentication.init([])
  let token_value: "1234"
  def put_token_in_header(conn, token), do: conn |> put_req_header("token", token)

  context "when an user has an opened session with the specified token" do
    let user: insert!(%User{})
    let session: insert!(%Session{token: token_value, user_id: user.id})
    let response: build_conn |> put_token_in_header(session.token) |> Authentication.call(opts)

    it do: expect response.assigns.current_user |> to(be_truthy)
  end

  context "when doesn't exist a session with the specified token" do
    let response: build_conn |> put_token_in_header(token_value) |> Authentication.call(opts)

    it do: expect response.status |> to(eq 401)
    it do: expect response.halted |> to(be_truthy)
  end

  context "when doesn't specify a token" do
    let response: Authentication.call(build_conn, opts)

    it do: expect response.status |> to(eq 401)
    it do: expect response.halted |> to(be_truthy)
  end
end
