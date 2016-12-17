defmodule Point.SessionControllerSpec do
  use ESpec.Phoenix, controller: Point.SessionController
  use ESpec.Phoenix.Helper
  alias Point.{Session, User, Repo, SessionService}

  let remote_ip: "127.0.0.1"
  let valid_attrs: %{email: "adrianmarino@gmail.com", password: "Whatever1123", first_name: "adrian", last_name: "marino"}

  describe "sign_in" do
    let response: post(put_remote_ip_in_header(build_conn, remote_ip), session_path(build_conn, :sign_in), user)

    before do: Repo.insert!(User.registration_changeset(%User{}, valid_attrs))

    context "when sign_in a session with a valid password" do
      let user: valid_attrs

      it do: expect response.status |> to(eq 201)

      it "response a token that has a session assigned" do
        token = json_response(response, 201)["token"]
        expect Repo.get_by(Session, token: token) |> to(be_truthy)
      end
    end

    context "when sign_in a session with an invalid password" do
      let user: Map.put(valid_attrs, :password, "invalid")

      it do: expect response.status |> to(eq 401)

      it "does not create resource and renders errors" do
        expect json_response(response, 401)["errors"] |> not_to(be_empty)
      end
    end

    context "when sign_in a session with an invalid email" do
      let user: Map.put(valid_attrs, :email, "invalid")

      it do: expect response.status |> to(eq 401)

      it "does not create resource and renders errors" do
        expect json_response(response, 401)["errors"] |> not_to(be_empty)
      end
    end
  end

  describe "sign_out" do
    let response: delete(put_token_in_header(build_conn, token), session_path(build_conn, :sign_out))

    context "when sign_out an opened session" do
      let! user: Repo.insert(User.registration_changeset(%User{}, valid_attrs))
      let :token do
        signin = post(put_remote_ip_in_header(build_conn, remote_ip), session_path(build_conn, :sign_in), valid_attrs)
        json_response(signin, 201)["token"]
      end

      before do: response

      it do: expect response.status |> to(eq 204)

      it "removes session from database" do
        expect SessionService.by(token: token) |> to(eq nil)
      end
    end

    xcontext "when sing_out an unknow session" do
      let token: "unknow"

      it do: expect response.status |> to(eq 204)
    end
  end
end
