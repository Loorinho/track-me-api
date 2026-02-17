defmodule TrackMeApi.Auth.GuardianErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, _reason}, _options) do
    body = Jason.encode!(%{message: to_string(type), status: "failed", succes: false})
    # body = Jason.encode!(%{error: to_string(type)})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end
