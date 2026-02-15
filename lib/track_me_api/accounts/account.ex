defmodule TrackMeApi.Accounts.Account do
  alias TrackMeApi.Users.User
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :email, :string
    field :hashed_password, :string

    has_one :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :hashed_password])
    # |> validate_required([:email, :hashed_password])
    |> validate_required([:email], message: "Email is required")
    |> validate_required([:hashed_password], message: "Password is required")
    |> validate_format(:email, ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
      message: "Provide a valid email address"
    )
    |> validate_length(:email, max: 50, message: "Email cannot be more than 50 characters")
    |> validate_length(:hashed_password,
      min: 12,
      message: "Password must be at least 12 characters long"
    )
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  # # If the changeset is valid, then we make some changes i.e hash the password
  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{hashed_password: plain_password}} = changeset
       ) do
    change(changeset, hashed_password: Bcrypt.hash_pwd_salt(plain_password))
  end

  # If the changeset is not valid, then we just return it
  defp put_password_hash(changeset), do: changeset
end
