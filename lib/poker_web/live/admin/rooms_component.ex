defmodule PokerWeb.Live.Admin.RoomsComponent do
  use Phoenix.LiveComponent

  def update(_assigns, socket) do
    rooms = Poker.Repo.Room.all()
    {:ok, assign(socket, :rooms, rooms)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <p :if={@rooms == []}>
        У селі тихо-тихо, тільки іноді сколихується тінь молодого деревця та між гіллям,
        розсипаючись, зашерхотить наростень паморозі...
      </p>
      <ul>
        <li :for={room <- @rooms}>
          <%= room.id %> :: <%= room.created_at |> Timex.format!("{h24}:{m}") %> :: <%= room_members(
            room
          ) %>
        </li>
      </ul>
    </div>
    """
  end

  defp room_members(room),
    do:
      room.members
      |> Enum.map(fn x -> Poker.Repo.User.get(x).username end)
      |> Enum.join(", ")
end
