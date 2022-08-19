defmodule Hangman.Impl.Game do
  alias Hangman.Type, as: Type

  @type t :: %Hangman.Impl.Game{
    turns_left: integer,
    game_state: Type.state(),
    letters: list(String.t),
    used: MapSet.t(String.t)
  }
  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )
  @spec new_game :: Hangman.Impl.Game.t()
  def new_game do
   new_game(Dictionary.random_word())
  end

  @spec new_game(String.t)::Hangman.Impl.Game.t()
  def new_game(word) do
    %Hangman.Impl.Game{
      letters: word |> String.codepoints()
    }
  end
end
