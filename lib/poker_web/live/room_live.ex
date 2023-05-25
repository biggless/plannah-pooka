defmodule PokerWeb.RoomLive do
  use PokerWeb, :live_view

  def mount(_params, session, socket) do
    with %{"user_id" => user_id} <- session,
         user when user != nil <- Poker.Repo.User.get(user_id) do
      {:ok, socket}
    else
      _ -> {:ok, push_redirect(socket, to: ~p"/auth")}
    end
  end

  def render(assigns) do
    ~H"""
    <header>
      Header
    </header>
    <div class="flex justify-center items-center min-h-screen bg-gray-100">
      <div class="bg-white p-8 rounded shadow-md flex">
        <div class="w-1/2 pr-4">
          left
        </div>
        <div class="w-1/2 pl-4 flex flex-col justify-center">
          right
        </div>
      </div>
    </div>
    """
  end

  # def handle_event("new-room", _params, socket) do
  #   {:noreply, socket}
  # end
end
