defmodule Point.EntityFactory do
  use ExMachina.Ecto, repo: Point.Repo
  alias Point.{Entity, UserFactory}

  def universe_factory do
    %Entity{
      code: "universe",
      name: "Universe Entity",
      users: [UserFactory.build(:chewbacca)]
    }
  end

  def rebelion_factory, do: %Entity{
    code: "rebelion",
    name: "Rebelion",
    users: [
      UserFactory.build(:luke_skywalker),
      UserFactory.build(:obiwan_kenoby)
    ]
  }

  def empire_factory do
    %Entity{
      code: "empire",
      name: "Empire",
      users: [
        UserFactory.build(:anakin_skywalker),
        UserFactory.build(:jango_fett)
      ]
    }
  end
end
