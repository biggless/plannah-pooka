defmodule Poker.Cleanup do
  use GenServer

  # 1 minute
  @period 60 * 1000

  def init(init_arg), do: tick() && {:ok, init_arg}

  def start_link(_), do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  def handle_info(:cleanup, state),
    do:
      Poker.Repo.User.cleanup() &&
        tick() &&
        {:noreply, state}

  defp tick(), do: Process.send_after(self(), :cleanup, @period)
end
