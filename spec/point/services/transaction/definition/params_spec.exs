defmodule Point.ParamsSpec do
  use ESpec

  describe "valid_params" do
    context "when doesn't found a required param" do
      let params: %{}
      let definition: %{to: %{user: %{email: :required}}}

      it "throws a required param error" do
        expect fn -> Params.valid_params(params(), definition()) end |> to(throw_term "to.user.email param is required!")
      end
    end

    context "when found a required param value" do
      let params: %{to: %{user: %{email: "adrianmarino@gmail.com"}}}
      let definition: %{to: %{user: %{email: :required}}}

      it "returns same params", do: expect Params.valid_params(params(), definition()) |> to(eq params())
    end

    context "when doesn't found a param with default value" do
      let params: %{}
      let definition: %{to: %{user: %{email: "adrianmarino@gmail.com"}}}

      it "assigns default value", do: expect Params.valid_params(params(), definition()) |> to(eq definition())
    end
  end
end
