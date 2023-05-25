defmodule PokerWeb.Router do
  use PokerWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PokerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admins_only do
    plug :admin_basic_auth
  end

  scope "/", PokerWeb do
    pipe_through :browser

    post "/auth", AuthController, :create
    live "/auth", AuthLive
    live "/", RoomLive
  end

  scope "/api", PokerWeb do
    pipe_through :api
  end

  scope "/admin" do
    pipe_through [:browser, :admins_only]

    live_dashboard "/dashboard",
      metrics: PokerWeb.Telemetry,
      additional_pages: [
        users: PokerWeb.Live.Admin.Users,
        rooms: PokerWeb.Live.Admin.Rooms
      ]
  end

  defp admin_basic_auth(conn, _opts) do
    username = System.fetch_env!("ADMIN_USERNAME")
    password = System.fetch_env!("ADMIN_PASSWORD")
    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end
end
