defmodule TrackMeApiWeb.DefaultController do
  use TrackMeApiWeb, :controller

  def index(conn, _params) do
    # text(conn, "We are up and running")
    data = %{message: "We are up and running", success: true}
    json(conn, data)
  end
end
