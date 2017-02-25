defmodule Point.RoleControllerSpec do
  use ESpec.Phoenix, controller: Point.RoleController
  use ESpec.Phoenix.Helper

  describe "index" do
    let response: sec_conn |> get(role_path(sec_conn, :index))
    let roles: json_response(response, 200)

    it "returns ok status", do: expect response.status |> to(eq 200)
    it "returns a list with three roles", do: expect roles |> to(have_size 3)
    it "returns a list that contains a system_admin role", do: expect roles |> to(have "system_admin")
    it "returns a list that contains a entity_admin role", do: expect roles |> to(have "entity_admin")
    it "returns a list that contains a normal_user role", do: expect roles |> to(have "normal_user")
  end
end
