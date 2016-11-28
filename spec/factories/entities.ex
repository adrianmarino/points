defmodule Point.EntityFactory do
  use ExMachina.Ecto, repo: Point.Repo
  alias Point.{Entity, UserFactory}

  def platform_factory do
    %Entity{name: "Point Platform", users: UserFactory.build_list(1, :root)}
  end

  def rio_factory, do: %Entity{name: "Rio", users: UserFactory.build_list(1, :obiwan_kenoby)}

  def boston_factory do
    %Entity{name: "Boston", users: UserFactory.build_list(1, :quigon_jinn)}
  end
end
