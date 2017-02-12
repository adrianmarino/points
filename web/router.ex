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

    pipe_through :private_api

    # Sessions
    delete "/sign_out", SessionController, :sign_out
    get "/sessions", SessionController, :index

    resources "/users", UserController, except: [:new, :edit], param: "email"
    resources "/currencies", CurrencyController, except: [:new, :edit], param: "code"

    scope "/accounts" do
      get "/", AccountController, :index
      get "/:owner_email/:currency_code", AccountController, :show

      post "/", AccountController, :create
      delete "/:owner_email/:currency_code", AccountController, :delete
    end

    scope "/exchange_rates" do
      get "/", ExchangeRateController, :index
      get "/:source/:target", ExchangeRateController, :show

      post "/", ExchangeRateController, :create
      delete "/:source/:target", ExchangeRateController, :delete

      put "/:source/:target", ExchangeRateController, :update
      patch "/:source/:target", ExchangeRateController, :update
    end

    scope "/transactions" do
      post "/:name/execute", TransactionController, :execute

      get "/", TransactionController, :index
      get "/:name", TransactionController, :show

      post "/:name", TransactionController, :create
      delete "/:name", TransactionController, :delete

      put "/:name", TransactionController, :update
      patch "/:name", TransactionController, :update
    end

    scope "/movements" do
      get "/:from/:to", MovementController, :search_between
      get "/:owner_email/:currency_code/:after", MovementController, :search_by_account_after
    end
  end
end
