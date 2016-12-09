defmodule Point.SessionSpec do
  use ESpec
  alias Point.Session

  let valid_attrs: %{user_id: "1"}
  let invalid_attrs: %{}

  describe "changeset" do
    let changeset: Session.changeset(%Session{}, attrs)
    context "when has valid attributes" do
      let attrs: valid_attrs
      it do: expect changeset.valid? |> to(be_truthy)
    end
    context "when has valid attributes" do
      let attrs: invalid_attrs
      it do: expect changeset.valid? |> to(be_falsy)
    end
  end

  describe "create_changeset" do
    let changeset: Session.create_changeset(%Session{}, attrs)
    context "when has valid attributes" do
      let attrs: valid_attrs
      it do: expect changeset.changes.token |> not_to(be_blank)
      it do: expect changeset.valid? |> to(be_truthy)
    end
    context "when has invalid attributes" do
      let attrs: invalid_attrs
      it do: expect changeset.valid? |> to(be_falsy)
    end
  end
end
