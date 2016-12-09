defmodule Point.Router do
  use Point.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Point do
    pipe_through :api

    scope "/v1" do
      resources "/users", UserController, except: [:new, :edit]
      resources "/sessions", SessionController, only: [:create]
    end
  end
end
