defmodule PokerWeb.AuthLive do
  use PokerWeb, :live_view

  def mount(_params, session, socket) do
    with %{"user_id" => user_id} <- session,
         user when user != nil <- Poker.Repo.User.get(user_id) do
      {:ok, push_redirect(socket, to: ~p"/")}
    else
      _ -> {:ok, assign(socket, sign_in: false)}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="flex justify-center items-center min-h-screen bg-gray-100">
      <div class="bg-white p-8 rounded shadow-md">
        <h2 class="text-2xl font-semibold mb-6">Розпізнавання</h2>
        <.form action={~p"/auth"} phx-submit="sign_in" phx-trigger-action={@sign_in}>
          <div class="mb-4">
            <label for="username" class="block text-gray-700 text-sm font-bold mb-2">Назвисько</label>
            <input
              type="username"
              id="username"
              class="w-full px-4 py-2 border border-gray-300 rounded focus:outline-none focus:border-indigo-500"
              name="username"
              placeholder="Степан Бандера"
              required
              autofocus
            />
          </div>
          <div>
            <button
              type="submit"
              class="w-full bg-indigo-500 text-white font-bold py-2 px-4 rounded focus:outline-none hover:bg-indigo-600"
            >
              Вхід
            </button>
          </div>
        </.form>
      </div>
    </div>
    """
  end

  def handle_params(_params, _url, socket),
    do: {:noreply, assign(socket, page_title: "Розпізнавання")}

  def handle_event("set_username", %{"username" => username}, socket),
    do: {:noreply, assign(socket, :username, username)}

  def handle_event("sign_in", %{"username" => username}, socket),
    do: {:noreply, assign(socket, username: username, sign_in: true)}
end
