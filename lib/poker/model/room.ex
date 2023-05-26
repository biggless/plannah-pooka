defmodule Poker.Model.Room do
  defstruct [:id, :created_by, :created_at, :members]

  def create(created_by),
    do:
      Poker.Repo.Room.insert(%__MODULE__{
        id: UUID.uuid4(),
        created_by: created_by,
        created_at: Timex.now("UTC"),
        members: []
      })

  def add_user(%__MODULE__{} = room, %Poker.Model.User{} = user),
    do: %__MODULE__{room | members: [user.id | room.members]}
end
