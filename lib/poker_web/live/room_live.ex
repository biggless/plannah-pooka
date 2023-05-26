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
        <.form
          action={~p"/auth"}
          phx-submit="join-room"
        >
          <div class="mb-4">
            <label for="username" class="block text-gray-700 text-sm font-bold mb-2">Код кімнати</label>
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
    In da room
    """
  end

  def handle_event("join-room", %{"roomcode" => roomcode}, socket) do
    user = socket.assigns.user

    room = case Poker.Repo.Room.get(roomcode) do
      nil -> Poker.Model.Room.create(user.id)
      %Poker.Model.Room{} = room -> room
    end

    room
    |> Poker.Model.Room.add_user(user)
    |> Poker.Repo.Room.update()

    {:noreply, assign(socket, room: room)}
  end
end
