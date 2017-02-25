defmodule Point.UserFactory do
  use ExMachina.Ecto, repo: Point.Repo
  alias Point.User

  def session_test_user_factory do
    %User{
      email: "firstname.lastname@test.com",
      password: "Whatever10",
      first_name: "TestFirstName",
      last_name: "TestLastName",
      role: :system_admin
    }
  end

  def chewbacca_factory do
    %User{
      email: sequence(:email, &"chewbacca#{&1}@gmail.com"),
      first_name: "chewbacca",
      last_name: "chewbacca",
      role: :system_admin
    }
  end

  def luke_skywalker_factory do
    %User{
      email: sequence(:email, &"lukeskywalker#{&1}@gmail.com"),
      first_name: "Luke",
      last_name: "Skywalker",
      role: :normal_user
    }
  end

  def obiwan_kenoby_factory do
    %User{
      email: sequence(:email, &"obiwankenoby#{&1}@gmail.com"),
      first_name: "Obi-Wan",
      last_name: "Kenoby",
      role: :normal_user
    }
  end

  def han_solo_factory do
    %User{
      email: sequence(:email, &"hansolo#{&1}@gmail.com"),
      first_name: "Han",
      last_name: "Solo",
      role: :normal_user
    }
  end

  def anakin_skywalker_factory do
    %User{
      email: sequence(:email, &"anakinskywalker#{&1}@gmail.com"),
      first_name: "Anakin",
      last_name: "Skywalker",
      role: :normal_user
    }
  end

  def jango_fett_factory do
    %User{
      email: sequence(:email, &"jangofett#{&1}@gmail.com"),
      first_name: "Jango",
      last_name: "Fett",
      role: :normal_user
    }
  end
end
