#This module is the API
defmodule Hangman do

  alias Hangman.Impl.Game, as: Game

  @type state :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used
  @opaque game:: Game.t
  @type tally :: %{
    turns_left: integer,
    game_state: state,
    letters: list(String.t),
    used: list(String.t)
  }
@spec new_game() :: game
# This line replace the next def ...
defdelegate new_game, to: Game
# def new_game do
#   Game.new_game()
# end
@spec make_move(game, String.t) :: { game, tally }
def make_move(_game, _guess) do

end

@spec sum(integer, integer) :: integer
def sum(a,b) do
  a+b
end
end
