defmodule Point.UserControllerSpec do
  use ESpec.Phoenix, controller: Point.UserController
  use ESpec.Phoenix.Helper

  let valid_attrs: %{email: "adrianmarino@gmail.com", password: "Whatever10", first_name: "2222", last_name: "222"}

  describe "create" do
    let response: sec_conn |> post(user_path(sec_conn, :create), attrs)

    context "when register a valid user" do
      let attrs: valid_attrs
      it "returns created status", do: expect response.status |> to(eq 201)
    end

    context "when register an invalid user" do
      let attrs: %{valid_attrs | password: "invalid"}
      it "returns unprocessable_entity status", do: expect response.status |> to(eq 422)
    end
  end

  describe "update" do
    context "when update with valid data" do
      it "returns ok status"
      it "returns last password"
      it "returns last first_name"
      it "returns last last_name"
    end
    context "when update with invalid data" do
      it "returns unprocessable_entity status"
      it "returns errors description"
    end
  end

  describe "delete" do
    context "when an exsitent user is deleted" do
      it "returns deleted status"
    end
    it "returns not found status when non-exist the transaction"
  end
end
