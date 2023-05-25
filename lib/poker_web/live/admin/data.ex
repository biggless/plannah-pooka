defmodule PokerWeb.Live.Admin.Data do
  use Phoenix.LiveDashboard.PageBuilder

  def menu_link(_, _) do
    {:ok, "Data"}
  end

  def render_page(_assigns) do
    {PokerWeb.Live.Admin.DataComponent, %{id: :data_component}}
  end
end
