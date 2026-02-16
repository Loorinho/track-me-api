defmodule TrackMeApiWeb.AccountJSON do
  alias TrackMeApi.Accounts.Account

  @doc """
  Renders a list of accounts.
  """
  def index(%{accounts: accounts}) do
    %{data: for(account <- accounts, do: data(account))}
  end

  @doc """
  Renders a single account.
  """
  def show(%{account: account, token: token}) do
    %{data: account_and_token(account, token), message: "success", success: true}
  end

  defp account_and_token(%Account{} = account, token) do
    %{
      account_id: account.id,
      email: account.email,
      token: token
    }
  end

  defp data(%Account{} = account) do
    %{
      id: account.id,
      email: account.email
    }
  end
end
