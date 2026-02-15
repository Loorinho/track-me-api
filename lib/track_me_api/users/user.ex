defmodule TrackMeApi.Users.User do
  use Ecto.Schema

  alias TrackMeApi.Accounts.Account
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :gender, :string
    field :username, :string
    field :active, :boolean

    belongs_to :account, Account

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:account_id, :first_name, :last_name, :gender, :username])
    |> validate_required([:account_id, :first_name, :last_name, :gender, :username])
  end
end
