defmodule PokerWeb.AuthController do
  use PokerWeb, :controller

  def create(conn, params) do
    case params do
      %{"username" => username} when is_binary(username) and username != "" ->
        user = Poker.Model.User.create(username)

        conn
        |> put_session(:user_id, user.id)
        |> redirect(to: "/")

      _ ->
        conn |> redirect(to: "/auth")
    end
  end
end
