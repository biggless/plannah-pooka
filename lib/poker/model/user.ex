defmodule Poker.Model.User do
  defstruct [:id, :username, :created_at]

  def create(username) do
    user = %__MODULE__{id: UUID.uuid4(), username: username, created_at: Timex.now("UTC")}
    Poker.Repo.User.insert(user)
    user
  end
end
