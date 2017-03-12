defmodule Point.EntityFactory do
  use ExMachina.Ecto, repo: Point.Repo
  alias Point.{Entity, UserFactory}

  def test_entity_factory do
    %Entity{
      code: "test_entity",
      name: "Test Entity",
      issuers: [UserFactory.insert(:session_test_user)]
    }
  end

  def universe_factory do
    %Entity{
      code: "universe",
      name: "Universe Entity",
      issuers: [UserFactory.build(:chewbacca)]
    }
  end

  def revelion_factory, do: %Entity{
    code: "revelion",
    name: "Revelion",
    issuers: [
      UserFactory.build(:luke_skywalker),
      UserFactory.build(:obiwan_kenoby)
    ]
  }

  def empire_factory do
    %Entity{
      code: "empire",
      name: "Empire",
      issuers: [
        UserFactory.build(:anakin_skywalker),
        UserFactory.build(:jango_fett)
      ]
    }
  end
end
