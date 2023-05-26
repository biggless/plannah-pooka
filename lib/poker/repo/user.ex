defmodule Poker.Repo.User do
  use GenServer

  # minutes
  @user_session_timeout 60

  # Client
  def start_link(_), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def insert(user), do: GenServer.call(__MODULE__, {:insert, user})

  def get(id), do: GenServer.call(__MODULE__, {:get, id})

  def all(), do: GenServer.call(__MODULE__, :all)

  def cleanup(), do: GenServer.cast(__MODULE__, :cleanup)

  # Server
  @impl true
  def init(opts), do: {:ok, opts}

  @impl true
  def handle_call({:insert, user}, _from, state),
    do: {:reply, user, Map.put(state, user.id, user)}

  @impl true
  def handle_call({:get, id}, _from, state), do: {:reply, Map.get(state, id), state}

  @impl true
  def handle_call(:all, _from, state), do: {:reply, Map.values(state), state}

  @impl true
  def handle_cast(:cleanup, state) do
    drop_ids =
      Map.values(state)
      |> Enum.filter(fn x ->
        Timex.diff(Timex.now("UTC"), x.created_at, :minutes) >= @user_session_timeout
      end)
      |> Enum.map(fn x -> x.id end)

    {:noreply, Map.drop(state, drop_ids)}
  end
end
