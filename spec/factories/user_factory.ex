defmodule Point.UserFactory do
  use ExMachina.Ecto, repo: Point.Repo
  alias Point.User

  def chewbacca_factory do
    %User{email: sequence(:email, &"chewbacca#{&1}@gmail.com"), first_name: "chewbacca", last_name: "chewbacca"}
  end

  def luke_skywalker_factory do
    %User{email: sequence(:email, &"lukeskywalker#{&1}@gmail.com"), first_name: "Luke", last_name: "Skywalker"}
  end

  def obiwan_kenoby_factory do
    %User{email: sequence(:email, &"obiwankenoby#{&1}@gmail.com"), first_name: "Obi-Wan", last_name: "Kenoby"}
  end

  def han_solo_factory do
    %User{email: sequence(:email, &"hansolo#{&1}@gmail.com"), first_name: "Han", last_name: "Solo"}
  end

  def anakin_skywalker_factory do
    %User{email: sequence(:email, &"anakinskywalker#{&1}@gmail.com"), first_name: "Anakin", last_name: "Skywalker"}
  end

  def jango_fett_factory do
    %User{email: sequence(:email, &"jangofett#{&1}@gmail.com"), first_name: "Jango", last_name: "Fett"}
  end
end
