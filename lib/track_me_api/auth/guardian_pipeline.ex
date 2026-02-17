defmodule TrackMeApi.Auth.GuardianPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :track_me_api,
    module: TrackMeApi.Auth.Guardian,
    error_handler: TrackMeApi.Auth.GuardianErrorHandler

  # The auth plugs

  # checks for the token in the session
  # if it is not there tries to look for it in the headers
  # if it is there, then we ensure that it is actually valid
  # if it is actually valid, then we try to load the resource the token refers to
  # If at least one of those fails, then they get a 401
  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
