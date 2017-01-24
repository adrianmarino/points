defmodule Point.Client.User do
  defstruct [:email, :password, :first_name, :last_name]

  def create(params) do
    %Point.Client.User{
      email: Enum.at(params, 0),
      password: Enum.at(params, 1),
      first_name: Enum.at(params, 2),
      last_name: Enum.at(params, 3)
    }
  end
end
