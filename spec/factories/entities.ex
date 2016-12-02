defmodule Point.EntityFactory do
  use ExMachina.Ecto, repo: Point.Repo
  alias Point.{Entity, UserFactory}

  def universe_factory do
    %Entity{
      name: "Universe Entity",
      users: [UserFactory.build(:chewbacca)]
    }
  end

  def revel_factory, do: %Entity{
    name: "Revelion",
    users: [
      UserFactory.build(:luke_skywalker),
      UserFactory.build(:obiwan_kenoby)
    ]
  }

  def boston_factory do
    %Entity{
      name: "Boston",
      users: [
        UserFactory.build(:anakin_skywalker),
        UserFactory.build(:jango_fett)
      ]
    }
  end
end
