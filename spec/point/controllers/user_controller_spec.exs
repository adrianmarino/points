defmodule Point.UserControllerSpec do
  use ESpec.Phoenix, controller: Point.UserController

  let valid_attrs: %{email: "adrianmarino@gmail.com", password: "Whatever10", first_name: "2222", last_name: "222"}
  let response: post(build_conn, user_path(build_conn, :create), user: attrs)

  before do: put_req_header(build_conn, "accept", "application/json")

  context "when register a valid user" do
    let attrs: valid_attrs
    it do: expect response.status |> to(eq 201)
  end

  context "when register an invalid user" do
    let attrs: Map.put(valid_attrs, :password, "invalid")
    it do: expect response.status |> to(eq 422)
  end
end
