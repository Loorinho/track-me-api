defmodule TrackMeApi.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TrackMeApi.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        first_name: "some first_name",
        gender: "some gender",
        last_name: "some last_name",
        username: "some username"
      })
      |> TrackMeApi.Users.create_user()

    user
  end
end
