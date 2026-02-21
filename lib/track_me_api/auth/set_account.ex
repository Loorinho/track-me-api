defmodule TrackMeApi.Auth.SetAccount do
  @moduledoc """
    This is the module plug which will set the account in the connection struct
    As long as user is authenticated, their account will always be in the connection
    iex> conn.assigns[:account]
  """
  import Plug.Conn
  alias TrackMeApi.Accounts
  alias TrackMeApi.Auth.ErrorResponse

  def init(_options) do
    # This function just initializes the options that are to be used in the call
  end

  def call(conn, _options) do
    if conn.assigns[:account] do
      # If the account is already in the assigns, just return the connection
      conn
    else
      # Otherwise we first try to get the account id from the session
      account_id = get_session(conn, :account_id)

      # If no account id is found in the session, then we raise an exception
      if account_id == nil, do: raise(ErrorResponse.Unauthorized)

      # Otherwise, we get the accound details from the db given the account_id
      account = Accounts.get_account!(account_id)

      cond do
        # If we successfully, get the account, we set it in the assigns under the :account key or just set it to nil if we have no account
        account_id && account -> assign(conn, :account, account)
        true -> assign(conn, :account, nil)
      end
    end
  end
end
