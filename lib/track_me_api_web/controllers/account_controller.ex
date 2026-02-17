defmodule TrackMeApiWeb.AccountController do
  use TrackMeApiWeb, :controller

  alias TrackMeApi.{
    Accounts,
    Accounts.Account,
    Users,
    Users.User,
    Auth.Guardian,
    Auth.ErrorResponse
  }

  action_fallback TrackMeApiWeb.FallbackController

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

  # We create an account, generate a token for it. If thats good, then we go ahead to create a user given that account
  def create_user_account(conn, %{"account" => account_params}) do
    # case  do
    #   {:error, errors} ->
    #     created_account = Accounts.get_account_by_email!(account_params["email"])
    #     IO.inspect(created_account, label: "Created account")
    #     Accounts.delete_account(created_account)
    #     errors
    # end

    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(account),
         {:ok, %User{} = _user} <- Users.create_user_from_account(account, account_params) do
      # IO.inspect(user, label: "Created user from account")

      conn
      |> put_status(:created)
      |> render(:show, account: account, token: token)
    else
      {:error, message} ->
        IO.inspect(message, label: "Error Message")
    end
  end

  def login_user(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, token, account} ->
        conn
        |> put_status(:ok)
        |> render(:show, account: account, token: token)

      {:error, :unauthorized} ->
        raise ErrorResponse.Unauthorized, message: "Invalid Credentials Supplied"
    end
  end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    render(conn, :get_account_details, account: account)
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{} = account} <- Accounts.update_account(account, account_params) do
      render(conn, :show, account: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
