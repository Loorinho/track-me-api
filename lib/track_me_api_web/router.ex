defmodule TrackMeApiWeb.Router do
  use TrackMeApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", TrackMeApiWeb do
    pipe_through :api

    get "/hello", DefaultController, :index

    post "/accounts/create", AccountController, :create_user_account
  end
end
