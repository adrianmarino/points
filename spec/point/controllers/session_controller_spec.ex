defmodule Point.SessionControllerSpec do
  use ESpec.Phoenix, controller: Point.SessionController
  alias Point.{Session, User, Repo}

  @valid_attrs %{email: "adrianmarino@gmail.com", password: "Whatever1123", first_name: "2222", last_name: "222"}
  let response: post(build_conn, session_path(build_conn, :sign_in), user)

  before do: Repo.insert!(User.registration_changeset(%User{}, @valid_attrs))

  context "when create a session with a valid password" do
    let user: @valid_attrs

    it do: expect response.status |> to(eq 201)

    it "response a token that has a session assigned" do
      token = json_response(response, 201)["token"]
      expect Repo.get_by(Session, token: token) |> to(be_truthy)
    end
  end

  context "when create a session with an invalid password" do
    let user: Map.put(@valid_attrs, :password, "invalid")

    it do: expect response.status |> to(eq 401)

    it "does not create resource and renders errors" do
      expect json_response(response, 401)["errors"] |> not_to(be_empty)
    end
  end

  context "when create a session with an invalid email" do
    let user: Map.put(@valid_attrs, :email, "invalid")

    it do: expect response.status |> to(eq 401)

    it "does not create resource and renders errors" do
      expect json_response(response, 401)["errors"] |> not_to(be_empty)
    end
  end
end
