defmodule Poker.Model.Room do
  defstruct [:id, :created_by, :created_at, members: [], votes: %{}]

  def create(code, created_by),
    do:
      Poker.Repo.Room.insert(%__MODULE__{
        id: code || UUID.uuid4(),
        created_by: created_by,
        created_at: Timex.now("UTC")
      })
end
