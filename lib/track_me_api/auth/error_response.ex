defmodule TrackMeApi.Auth.ErrorResponse.Unauthorized do
  defexception message: "Unauthorized", plug_status: 401, status: "failed", success: false
end
