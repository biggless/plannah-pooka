defmodule Poker.Repo.Room do
  use GenServer

  # Client
  def start_link(_), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def insert(room), do: GenServer.call(__MODULE__, {:insert, room})

  def all(), do: GenServer.call(__MODULE__, :all)

  def get(id), do: GenServer.call(__MODULE__, {:get, id})

  def get_by_user_id(user_id),
    do: Enum.find(all(), fn room -> room.members |> Enum.any?(fn id -> id == user_id end) end)

  def add_user(room_id, user_id), do: GenServer.call(__MODULE__, {:add_user, room_id, user_id})

  def add_vote(room_id, user_id, vote),
    do: GenServer.call(__MODULE__, {:add_vote, room_id, user_id, vote})

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
  def handle_call({:add_user, room_id, user_id}, _from, state) do
    room = Map.get(state, room_id)
    room = %Poker.Model.Room{room | members: [user_id | room.members]}
    Phoenix.PubSub.broadcast(Poker.PubSub, "room:#{room.id}", {:room_updated, room})
    {
      :reply,
      room,
      Map.put(state, room_id, room)
    }
  end

  @impl true
  def handle_call({:add_vote, room_id, user_id, vote}, _from, state) do
    room = Map.get(state, room_id)
    room = %Poker.Model.Room{room | votes: Map.put(room.votes, user_id, vote)}
    Phoenix.PubSub.broadcast(Poker.PubSub, "room:#{room.id}", {:room_updated, room})
    {
      :reply,
      room,
      Map.put(state, room_id, room)
    }
  end
end
