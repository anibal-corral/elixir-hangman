defmodule Hangman.Runtime.Server do
  @type t :: pid

  use GenServer
  alias Hangman.Impl.Game

  # THis is for starting the generic server
  #Client Process

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  #Server process
  @spec init(any) :: {:ok, Hangman.Impl.Game.t()}
  def init(_) do
    #the Job is returning a tuple with the ok and the state
    {:ok, Game.new_game} #Here the state is the hangman game

  end
def handle_call({:make_move, guess}, _from, state) do
  { updated_game, tally } = Game.make_move(state, guess)
  {:reply, tally, updated_game}
end

def handle_call({:tally}, _from, state) do
  {:reply, Game.tally(state), state}
end

end
