defmodule Poker.Model.Room do
  defstruct [:id, :created_by, :created_at, :members]

  def create(created_by) do
    room = %__MODULE__{
      id: UUID.uuid4(),
      created_by: created_by,
      created_at: Timex.now("UTC"),
      members: [created_by]
    }

    Poker.Repo.Room.insert(room)
    room
  end
end
