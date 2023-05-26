defmodule Poker.Model.User do
  defstruct [:id, :username, :created_at]

  def create(username),
    do:
      Poker.Repo.User.insert(%__MODULE__{
        id: UUID.uuid4(),
        username: username,
        created_at: Timex.now("UTC")
      })
end
