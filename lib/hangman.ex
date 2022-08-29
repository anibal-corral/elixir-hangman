#This module is the API
defmodule Hangman do

  alias Hangman.Impl.Game, as: Game
  alias Hangman.Type, as: Type
  alias Hangman.Runtime.Server

  @opaque game:: Server.t

@spec new_game() :: game
# This line replace the next def ...
# defdelegate new_game, to: Game
# def new_game do
#   Game.new_game()
# end
def new_game() do
  {:ok, pid} = Server.start_link()
  pid
end
@spec make_move(game, String.t) :: { game, Type.tally }
# defdelegate make_move(game, guess), to: Game
# def make_move(game, guess) do
# end

def make_move(game, guess) do
  GenServer.call(game, {:make_move, guess})
end

@spec sum(integer, integer) :: integer
def sum(a,b) do
  a+b
end

@spec tally(game) :: Type.tally()
# defdelegate tally(game), to: Game
def tally(game)  do
  GenServer.call(game, {:tally})
end
end
