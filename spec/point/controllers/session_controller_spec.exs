defmodule Point.SessionControllerSpec do
  use ESpec.Phoenix, controller: Point.SessionController
  use ESpec.Phoenix.Helper
  import Point.MapUtil, only: [sub_map: 2]
  alias Point.{Session, UserService, SessionService}

  let ip: "127.0.0.1"
  let valid_user_attrs: %{email: "adrianmarino@gmail.com", password: "Whatever1123", first_name: "adrian",
    last_name: "marino"}
  let valid_attrs: sub_map(valid_user_attrs, [:email, :password])

  describe "sign_in" do
    let response: post(remote_ip(build_conn, ip), session_path(build_conn, :sign_in), attrs)
    before do: UserService.register!(valid_user_attrs)

    context "when a valid session is opened" do
      let attrs: valid_attrs

      it "returns created status", do: expect response.status |> to(eq 201)

      it "responses with a token" do
        token = json_response(response, 201)["token"]
        expect SessionService.by(token: token) |> to(be_truthy)
      end
    end

    context "when a session with invalid password is opened" do
      let attrs: %{valid_attrs | password: "invalid"}

      it "returns unauthorized status", do: expect response.status |> to(eq 401)

      it "doesn't create a session and renders errors" do
        expect json_response(response, 401)["errors"] |> not_to(be_empty)
      end
    end

    context "when a session with invalid email is opened" do
      let attrs: %{valid_attrs | email: "invalid"}

      it "returns unauthorized status", do: expect response.status |> to(eq 401)
      it "doesn't create a session and renders errors" do
        expect json_response(response, 401)["errors"] |> not_to(be_empty)
      end
    end
  end

  describe "sign_out" do
    let response: delete(put_token_in_header(build_conn, token), session_path(build_conn, :sign_out))

    context "when a previously session is closed" do
      let sign_in: post(remote_ip(build_conn, ip), session_path(build_conn, :sign_in), valid_user_attrs)
      let token: json_response(sign_in, 201)["token"]
      before do
        UserService.register!(valid_user_attrs)
        sign_in
        response
      end

      it "returns deleted status", do: expect response.status |> to(eq 204)
      it "removes session from database", do: expect SessionService.by(token: token) |> to(eq nil)
    end

    context "when an non-existent session is closed" do
      let token: "unexistent"
      it "returns unauthorized status", do: expect response.status |> to(eq 401)
    end
  end

  describe "index" do
    it "returns ok status"
    it "returns sessions"
  end
end
