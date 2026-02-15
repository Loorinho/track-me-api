defmodule TrackMeApi.Repo do
  use Ecto.Repo,
    otp_app: :track_me_api,
    adapter: Ecto.Adapters.Postgres
end
