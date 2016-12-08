defmodule Point.UserSpec do
  use ESpec
  alias Point.User
  import Map, only: [put: 3]

  context "changeset" do
    let valid_attrs: %{email: "adrianmarino@gmail.com", first_name: "Adrian", last_name: "Marino"}
    let changeset: User.changeset(%User{}, attrs)

    context "when any field is empty" do
      let attrs: valid_attrs
      it do: expect changeset.valid? |> to(be_truthy)
    end
    context "when email is empty" do
      let attrs: put(valid_attrs, :email, "")
      it do: expect changeset.valid? |> to(be_falsy)
    end
    context "when first name is empty" do
      let attrs: put(valid_attrs, :first_name, "")
      it do: expect changeset.valid? |> to(be_falsy)
    end
    context "when last name is empty" do
      let attrs: put(valid_attrs, :last_name, "")
      it do: expect changeset.valid? |> to(be_falsy)
    end
    context "when email with invalid format" do
      let attrs: put(valid_attrs, :email, "foo.bar")
      it do: expect changeset.valid? |> to(be_falsy)
    end
  end

  context "registration_changeset" do
    let valid_attrs: %{email: "adrianmarino@gmail.com", password: "Whatever10", first_name: "Adrian", last_name: "Marino"}
    let registration_changeset: User.registration_changeset(%User{}, attrs)

    context "when password is valid" do
      let attrs: valid_attrs
      it do: expect registration_changeset.changes.password_hash |> not_to(be_empty)
      it do: expect registration_changeset.valid? |> to(be_truthy)
    end

    context "when password is empty" do
      let attrs: put(valid_attrs, :password, "")
      it do: expect registration_changeset.valid? |> to(be_falsy)
    end

    context "when password size is less than 10" do
      let attrs: put(valid_attrs, :password, "123")
      it do: expect registration_changeset.valid? |> to(be_falsy)
    end
  end
end
