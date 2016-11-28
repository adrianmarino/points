defmodule Point.UserFactory do
  use ExMachina.Ecto, repo: Point.Repo
  alias Point.User

  def root_factory do
    %User{email: "jangofett@gmail.com", password: "1234A", first_name: "Jango", last_name: "Fett"}
  end

  def obiwan_kenoby_factory do
    %User{email: "obiwankenoby@gmail.com", password: "1234B", first_name: "Obi-Wan", last_name: "Kenoby"}
  end

  def anakin_skywalker_factory do
    %User{email: "anakinskywalker@gmail.com", password: "1234B", first_name: "Anakin", last_name: "Skywalker"}
  end

  def quigon_jinn_factory do
    %User{email: "quigonjinn@gmail.com", password: "1234B", first_name: "Qui-Gon", last_name: "Jinn"}
  end
end
