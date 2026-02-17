defmodule TrackMeApiWeb.Router do
  use TrackMeApiWeb, :router
  use Plug.ErrorHandler

  def handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn
    |> json(%{errors: message})
    # This halt stops the execution of any other downstream plugs

    |> halt()
  end

  def handle_errors(conn, %{message: message}) do
    conn
    |> json(%{errors: message})
    # This halt stops the execution of any other downstream plugs
    |> halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", TrackMeApiWeb do
    pipe_through :api

    get "/hello", DefaultController, :index

    post "/accounts/create", AccountController, :create_user_account
    post "/accounts/login", AccountController, :login_user
  end
end
