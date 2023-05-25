defmodule PokerWeb.Live.Admin.Users do
  use Phoenix.LiveDashboard.PageBuilder

  def menu_link(_, _) do
    {:ok, "Users"}
  end

  def render_page(_assigns) do
    {PokerWeb.Live.Admin.UsersComponent, %{id: :users_component}}
  end
end
