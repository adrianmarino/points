defmodule Point.UserSpec do
  use ESpec
  alias Point.User

  context "first_last_name_changeset" do
    let valid_attrs: %{first_name: "Adrian", last_name: "Marino"}
    let changeset: User.first_last_name_changeset(%User{}, attrs())

    context "when any field is empty" do
      let attrs: valid_attrs()
      it do: expect changeset().valid? |> to(be_truthy())
    end
    context "when first name is empty" do
      let attrs: %{valid_attrs() | first_name: ""}
      it do: expect changeset().valid? |> to(be_falsy())
    end
    context "when last name is empty" do
      let attrs: %{valid_attrs() | last_name: ""}
      it do: expect changeset().valid? |> to(be_falsy())
    end
  end

  context "role_changeset" do
    let changeset: User.role_changeset(%User{}, attrs())

    context "when has a valid role" do
      let attrs: %{role: :normal_user}
      it do: expect changeset().valid? |> to(be_truthy())
    end
    context "when an unknow role" do
      let attrs: %{role: :any}
      it do: expect changeset().valid? |> to(be_falsy())
    end
    context "when hasn't role" do
      let attrs: %{}
      it do: expect changeset().valid? |> to(be_falsy())
    end
  end

  context "password_changeset" do
    let changeset: User.password_changeset(%User{}, attrs())

    context "when password is valid" do
      let attrs: %{password: "Whatever10"}
      it do: expect changeset().changes.password_hash |> not_to(be_empty())
      it do: expect changeset().valid? |> to(be_truthy())
    end

    context "when password is empty" do
      let attrs: %{password: ""}
      it do: expect changeset().valid? |> to(be_falsy())
    end

    context "when password size is less than 10" do
      let attrs: %{password: 123}
      it do: expect changeset().valid? |> to(be_falsy())
    end
  end

  context "email_changeset" do
    let changeset: User.email_changeset(%User{}, attrs())

    context "when email is valid" do
      let attrs: %{email: "adrianmarino@gmail.com"}
      it do: expect changeset().valid? |> to(be_truthy())
    end

    context "when email is empty" do
      let attrs: %{email: ""}
      it do: expect changeset().valid? |> to(be_falsy())
    end

    context "when email with invalid format" do
      let attrs: %{email: "foo.bar"}
      it do: expect changeset().valid? |> to(be_falsy())
    end
  end

  context "insert_changeset" do
    let attrs: %{
      email: "adrianmarino@gmail.com",
      password: "Whatever10",
      first_name: "Adrian",
      last_name: "Marino",
      role: "normal_user"
    }
    let changeset: User.insert_changeset(%User{}, attrs())

    it do: expect changeset().valid? |> to(be_truthy())
  end

  context "update_changeset" do
    let attrs: %{
      password: "Whatever10",
      first_name: "Adrian",
      last_name: "Marino",
      role: "normal_user"
    }
    let changeset: User.update_changeset(%User{}, attrs())

    it do: expect changeset().valid? |> to(be_truthy())
  end
end
