defmodule PokerWeb.Live.Admin.UsersComponent do
  use Phoenix.LiveComponent

  def update(_assigns, socket) do
    users = Poker.Repo.User.all()
    {:ok, assign(socket, :users, users)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <p :if={@users == []}>
        У селі тихо-тихо, тільки іноді сколихується тінь молодого деревця та між гіллям,
        розсипаючись, зашерхотить наростень паморозі...
      </p>
      <ul>
        <li :for={user <- @users}>
          <%= user.username %> :: <%= user.created_at |> Timex.format!("{h24}:{m}") %>
        </li>
      </ul>
    </div>
    """
  end
end
