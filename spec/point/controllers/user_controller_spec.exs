defmodule Point.UserControllerSpec do
  use ESpec.Phoenix, controller: Point.UserController
  use ConnectionHelper

  let valid_attrs: %{email: "adrianmarino@gmail.com", password: "Whatever10", first_name: "2222", last_name: "222"}
  let response: build_conn |> put_token_in_header(current_session.token) |> post(user_path(build_conn, :create), attrs)

  context "when register a valid user" do
    let attrs: valid_attrs
    it do: expect response.status |> to(eq 201)
  end

  context "when register an invalid user" do
    let attrs: Map.put(valid_attrs, :password, "invalid")
    it do: expect response.status |> to(eq 422)
  end
end
