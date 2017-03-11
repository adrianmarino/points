defmodule Point.AuthenticationSpec do
  use ESpec.Phoenix, controller: Point.Authentication
  use ESpec.Phoenix.Helper
  import Point.Phoenix.ConnUtil

  let opts: described_module().init([])

  context "when an user has an opened session with the specified token" do
    let response: build_conn() |> put_token_in_header(session_token()) |> described_module().call(opts())

    it do: expect current_session(response()) |> to(be_truthy())
  end

  context "when doesn't exist a session with the specified token" do
    let token: "1234"
    let response: build_conn() |> put_token_in_header(token()) |> described_module().call(opts())

    it do: expect response().status |> to(eq 401)
    it do: expect response().halted |> to(be_truthy())
  end

  context "when doesn't specify a token" do
    let response: described_module().call(build_conn(), opts())

    it do: expect response().status |> to(eq 401)
    it do: expect response().halted |> to(be_truthy())
  end
end
