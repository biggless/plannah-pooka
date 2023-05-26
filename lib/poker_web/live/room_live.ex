defmodule PokerWeb.RoomLive do
  use PokerWeb, :live_view

  def mount(_params, session, socket) do
    with %{"user_id" => user_id} <- session,
         user when user != nil <- Poker.Repo.User.get(user_id),
         room <- Poker.Repo.Room.get_by_user_id(user.id) do
      {:ok, assign(socket, user: user, roomcode: "", room: room)}
    else
      _ -> {:ok, push_redirect(socket, to: ~p"/auth")}
    end
  end

  def render(%{room: nil} = assigns) do
    ~H"""
    <div class="flex justify-center items-center min-h-screen bg-gray-100">
      <div class="bg-white p-8 rounded shadow-md">
        <h2 class="text-2xl font-semibold mb-6">Кімната</h2>
        <.form action={~p"/auth"} phx-submit="join-room">
          <div class="mb-4">
            <label for="username" class="block text-gray-700 text-sm font-bold mb-2">
              Код кімнати
            </label>
            <input
              type="text"
              id="roomcode"
              class="w-full px-4 py-2 border border-gray-300 rounded focus:outline-none focus:border-indigo-500"
              name="roomcode"
              value={@roomcode}
              autofocus
            />
          </div>
          <div>
            <button
              type="submit"
              class="w-full bg-indigo-500 text-white font-bold py-2 px-4 rounded focus:outline-none hover:bg-indigo-600"
            >
              До кімнати
            </button>
          </div>
        </.form>
      </div>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div class="flex">
      <div class="w-1/4">
        <button
          :for={i <- [1, 3, 5, 8, 13, 20, 40, 100, "😱", "☕️"]}
          class="w-3/4 bg-indigo-500 text-white font-bold py-2 px-4 rounded focus:outline-none hover:bg-indigo-600 m-4"
          phx-click="vote"
          phx-value-vote={i}
        >
          <%= i %>
        </button>
      </div>
      <div class="w-3/4">
        <%= inspect(@room) %>
      </div>
    </div>
    """
  end

  def handle_event("join-room", %{"roomcode" => roomcode}, socket) do
    user = socket.assigns.user

    room =
      case Poker.Repo.Room.get(roomcode) do
        nil -> Poker.Model.Room.create(roomcode, user.id)
        %Poker.Model.Room{} = room -> room
      end

    Poker.Repo.Room.add_user(room.id, user.id)
    {:noreply, assign(socket, room: room)}
  end

  def handle_event("vote", %{"vote" => vote}, socket) do
    Poker.Repo.Room.add_vote(socket.assigns.room.id, socket.assigns.user.id, vote)
    {:noreply, socket}
  end
end
