defmodule Point.Router do
  use Point.Web, :router

  pipeline :public_api, do: plug :accepts, ["json"]
  pipeline :private_api do
    plug :accepts, ["json"]
    plug Point.Authentication
  end

  scope "/api/v1", Point do
    pipe_through :public_api
    post "/sign_in", SessionController, :sign_in

    pipe_through :public_api
    resources "/users", UserController, except: [:new, :edit]
  end
end
