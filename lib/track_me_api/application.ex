defmodule TrackMeApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TrackMeApiWeb.Telemetry,
      TrackMeApi.Repo,
      {DNSCluster, query: Application.get_env(:track_me_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TrackMeApi.PubSub},
      # Start a worker by calling: TrackMeApi.Worker.start_link(arg)
      # {TrackMeApi.Worker, arg},
      # Start to serve requests, typically the last entry
      TrackMeApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TrackMeApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TrackMeApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
