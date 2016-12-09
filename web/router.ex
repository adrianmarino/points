defmodule Point.Router do
  use Point.Web, :router

  pipeline :public_api, do: plug :accepts, ["json"]
  pipeline :private_api do
    plug :accepts, ["json"]
    plug Point.Authentication
  end

  scope "/api", Point do
    scope "/v1" do
      pipe_through :public_api
      resources "/sessions", SessionController, only: [:create]

      pipe_through :private_api
      resources "/users", UserController, except: [:new, :edit]
    end
  end
end
