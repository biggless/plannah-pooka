defmodule Poker.Repo.Room do
  use GenServer

  # Client
  def start_link(_), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def insert(room), do: GenServer.call(__MODULE__, {:insert, room})

  def all(), do: GenServer.call(__MODULE__, :all)

  def get_by_user_id(user_id),
    do:
      all()
      |> Enum.find(fn room -> room.members |> Enum.any?(fn id -> id == user_id end) end)

  def update(room), do: GenServer.call(__MODULE__, {:update, room})

  # Server
  @impl true
  def init(opts), do: {:ok, opts}

  @impl true
  def handle_call({:insert, room}, _from, state),
    do: {:reply, room, Map.put(state, room.id, room)}

  @impl true
  def handle_call(:all, _from, state), do: {:reply, Map.values(state), state}

  @impl true
  def handle_call({:update, room}, _from, state),
    do: {:reply, room, Map.put(state, room.id, room)}
end
