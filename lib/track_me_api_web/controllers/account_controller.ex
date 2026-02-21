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

  # Our plug middleware will only be invoked when we are trying to access the update function
  plug :is_authorized_account when action in [:update_account_details]

  action_fallback TrackMeApiWeb.FallbackController

  defp is_authorized_account(conn, _options) do
    %{params: %{"account" => account_params}} = conn

    account = Accounts.get_account!(account_params["id"])

    if conn.assigns.account.id == account.id do
      # We just making sure that the user trying to update an account is actually the user who logged in
      conn
    else
      # If the id of the account we are trying to update is not the id of the session, then we raise a forbidden error
      raise ErrorResponse.Forbidden
    end
  end

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
    end
  end

  def login_user(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, token, account} ->
        conn
        # putting the account id in the session
        |> Plug.Conn.put_session(:account_id, account.id)
        |> put_status(:ok)
        |> render(:show, account: account, token: token)

      {:error, :unauthorized} ->
        raise ErrorResponse.Unauthorized, message: "Invalid Credentials Supplied"
    end
  end

  def show(%Plug.Conn{} = conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    # We can actually get the account details from the connection without need for one to pass in the id parameter
    # account = conn.assigns.account
    render(conn, :get_account_details, account: account)
  end

  def update_account_details(conn, %{"account" => account_params}) do
    user_account = Accounts.get_account!(account_params["id"])

    with {:ok, %Account{} = account} <- Accounts.update_account(user_account, account_params),
         {:ok, %User{} = _user} <- Users.update_user(account.user, account_params) do
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
