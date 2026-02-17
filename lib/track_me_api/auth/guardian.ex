defmodule TrackMeApi.Auth.Guardian do
  use Guardian, otp_app: :track_me_api
  alias TrackMeApi.Accounts

  def subject_for_token(%{id: user_id}, _claims) do
    subject = to_string(user_id)
    {:ok, subject}
  end

  def subject_for_token(_, _claims) do
    {:error, "User Id not provided"}
  end

  def resource_from_claims(%{"sub" => subject_id}) do
    case Accounts.get_account!(subject_id) do
      nil -> {:error, "User not found"}
      account -> {:ok, account}
    end
  end

  def resource_from_claims(_claims) do
    {:error, "User Id not provided"}
  end

  # public function which authenticates user

  @doc """
    Authenticates a user

    ##Exaple
    iex> Guardian.authenticate("test@gmail.com", "testPassword")
    {:ok. token, account}

    iex> Guardian.authenticate("test@gmail.com", "testPassword")
     {:error, "Invalid username or password"}

  """
  def authenticate(email, password) do
    case Accounts.get_account_by_email!(email) do
      nil ->
        # {:error, "Invalid username or password"}
        {:error, :unauthorized}

      account ->
        case validate_password(password, account.hashed_password) do
          true ->
            {:ok, token} = create_token(account)
            {:ok, token, account}

          false ->
            # {:error, "Invalid username or password"}
            {:error, :unauthorized}
        end
    end
  end

  defp validate_password(password, hashed_password) do
    Bcrypt.verify_pass(password, hashed_password)
  end

  defp create_token(account) do
    # creates our token
    {:ok, token, _claims} = encode_and_sign(account)

    {:ok, token}
  end
end
