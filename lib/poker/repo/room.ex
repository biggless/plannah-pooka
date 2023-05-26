defmodule Poker.Repo.Room do
  use GenServer

  # Client
  def start_link(_), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def insert(room), do: GenServer.call(__MODULE__, {:insert, room})

  def all(), do: GenServer.call(__MODULE__, :all)

  def get(id), do: GenServer.call(__MODULE__, {:get, id})

  def get_by_user_id(user_id), do:
    Enum.find(all(), fn room -> room.members |> Enum.any?(fn id -> id == user_id end) end)

  def update(room), do: GenServer.call(__MODULE__, {:update, room})

  def add_user(room, user), do: GenServer.call(__MODULE__, {:add_user, room, user})

  def add_vote(room, user, vote), do: GenServer.call(__MODULE__, {:add_vote, room, user, vote})

  # Server
  @impl true
  def init(opts), do: {:ok, opts}

  @impl true
  def handle_call({:insert, room}, _from, state),
    do: {:reply, room, Map.put(state, room.id, room)}

  @impl true
  def handle_call({:get, id}, _from, state), do: {:reply, Map.get(state, id), state}

  @impl true
  def handle_call(:all, _from, state), do: {:reply, Map.values(state), state}

  @impl true
  def handle_call({:update, room}, _from, state),
    do: {:reply, room, Map.put(state, room.id, room)}

  @impl true
  def handle_call({:add_user, room, user}, _from, state) do
    room = Map.get(state, room.id)
    {
      :reply,
      room,
      Map.put(state, room.id, %Poker.Model.Room{room | members: [user.id | room.members]})
    }
  end

  @impl true
  def handle_call({:add_vote, room, user, vote}, _from, state) do
    room = Map.get(state, room.id)
    {
      :reply,
      room,
      Map.put(state, room.id, %Poker.Model.Room{room | votes: Map.put(room.votes, user.id, vote)})
    }
  end
end
