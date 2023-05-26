defmodule PokerWeb.RoomLive do
  use PokerWeb, :live_view

  def mount(_params, session, socket) do
    with %{"user_id" => user_id} <- session,
         user when user != nil <- Poker.Repo.User.get(user_id),
         room <- Poker.Repo.Room.get_by_user_id(user.id) do
      {:ok, assign(socket, user: user, room: room)}
    else
      _ -> {:ok, push_redirect(socket, to: ~p"/auth")}
    end
  end

  def render(%{room: nil} = assigns) do
    ~H"""
    <div class="flex justify-center items-center min-h-screen bg-gray-100">
      <div class="bg-white p-8 rounded shadow-md flex">
        <div class="w-1/2 pr-4">
          <button
            type="button"
            class="w-full bg-indigo-500 text-white font-bold py-2 px-4 rounded focus:outline-none hover:bg-indigo-600"
            phx-click="new-room"
          >
            Create room
          </button>
        </div>
        <div class="w-1/2 pl-4 flex flex-col justify-center">
          <p>Join</p>
          <p>Room</p>
        </div>
      </div>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    In da room
    """
  end

  def handle_event("new-room", _params, socket) do
    user = socket.assigns.user
    room = Poker.Model.Room.create(user.id)
    join_room(user, room)
    {:noreply, assign(socket, user: user, room: room)}
  end

  defp join_room(user, room),
    do:
      room
      |> Poker.Model.Room.add_user(user)
      |> Poker.Repo.Room.update()
end
