defmodule TrackMeApi.Auth.ErrorResponse.Unauthorized do
  defexception message: "Unauthorized", plug_status: 401, status: "failed", success: false
end

defmodule TrackMeApi.Auth.ErrorResponse.Forbidden do
  defexception message: "You are not allowed to perform this action",
               plug_status: 403,
               status: "failed",
               success: false
end
