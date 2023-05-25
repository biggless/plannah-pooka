defmodule PokerWeb.RoomLive do
  use PokerWeb, :live_view

  def mount(_params, session, socket) do
    with %{"user_id" => user_id} <- session,
         user when user != nil <- Poker.Repo.User.get(user_id) do
      {:ok, assign(socket, :user, user)}
    else
      _ -> {:ok, push_redirect(socket, to: ~p"/auth")}
    end
  end

  def render(assigns) do
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

  def handle_event("new-room", _params, socket) do
    user = socket.assigns.user
    room = Poker.Model.Room.create(user.id)
    IO.inspect("##############")
    IO.inspect("##############")
    IO.inspect(room)
    {:noreply, socket}
  end
end
