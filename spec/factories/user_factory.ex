defmodule Point.UserFactory do
  use ExMachina.Ecto, repo: Point.Repo
  alias Point.User

  def chewbacca_factory do
    %User{email: "chewbacca@gmail.com", password: "1234A", first_name: "chewbacca", last_name: ""}
  end

  def luke_skywalker_factory do
    %User{email: "lukeskywalker@gmail.com", password: "1234A", first_name: "Luke", last_name: "Skywalker"}
  end

  def obiwan_kenoby_factory do
    %User{email: "obiwankenoby@gmail.com", password: "1234B", first_name: "Obi-Wan", last_name: "Kenoby"}
  end

  def han_solo_factory do
    %User{email: "hansolo@gmail.com", password: "1234B", first_name: "Han", last_name: "Solo"}
  end

  def anakin_skywalker_factory do
    %User{email: "anakinskywalker@gmail.com", password: "1234B", first_name: "Anakin", last_name: "Skywalker"}
  end

  def jango_fett_factory do
    %User{email: "jangofett@gmail.com", password: "1234A", first_name: "Jango", last_name: "Fett"}
  end
end
