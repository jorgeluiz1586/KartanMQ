defmodule Kartanmq.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      KartanmqWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:kartanmq, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Kartanmq.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Kartanmq.Finch},
      # Start a worker by calling: Kartanmq.Worker.start_link(arg)
      # {Kartanmq.Worker, arg},
      # Start to serve requests, typically the last entry
      KartanmqWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kartanmq.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KartanmqWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
