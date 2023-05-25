defmodule Poker.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PokerWeb.Telemetry,
      {Phoenix.PubSub, name: Poker.PubSub},
      PokerWeb.Endpoint,
      Poker.Repo.User,
      Poker.Cleanup
    ]

    opts = [strategy: :one_for_one, name: Poker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    PokerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
