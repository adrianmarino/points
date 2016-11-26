defmodule Point.Router do
  use Point.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Point do
    pipe_through :api
  end
end
