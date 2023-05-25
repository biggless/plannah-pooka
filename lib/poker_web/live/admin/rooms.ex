defmodule PokerWeb.Live.Admin.Rooms do
  use Phoenix.LiveDashboard.PageBuilder

  def menu_link(_, _) do
    {:ok, "Rooms"}
  end

  def render_page(_assigns) do
    {PokerWeb.Live.Admin.RoomsComponent, %{id: :rooms_component}}
  end
end
