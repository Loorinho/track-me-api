defmodule TrackMeApiWeb.Router do
  use TrackMeApiWeb, :router
  use Plug.ErrorHandler

  def handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn
    |> json(%{message: message, status: "failed", success: false})
    # This halt stops the execution of any other downstream plugs

    |> halt()
  end

  def handle_errors(conn, %{reason: %{message: message, status: status, success: success}}) do
    conn
    |> json(%{message: message, status: status, success: success})
    # This halt stops the execution of any other downstream plugs
    |> halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug TrackMeApi.Auth.GuardianPipeline
  end

  scope "/api/v1", TrackMeApiWeb do
    pipe_through :api

    get "/hello", DefaultController, :index

    post "/accounts/create", AccountController, :create_user_account
    post "/accounts/login", AccountController, :login_user
  end

  # This is the scope for the protected routes
  scope "/api/v1", TrackMeApiWeb do
    pipe_through [:api, :auth]

    get "/accounts/:id", AccountController, :show
  end
end
