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


  ######################################################
  @spec make_move(t, String.t) :: { t, Type.tally }
  #This function is executed IF ONLY IF the state is :won or :lost
   def make_move(game = %{ game_state: state }, _guess) when state in [:won, :lost] do

    game
    |> return_with_tally()
  end
  # These lines are refactorized by the above lines.
  #  def make_move(game = %{ game_state: :won }, _guess) do
  #   { game, tally(game)}
  # end

  # def make_move(game = %{ game_state: :lost }, _guess) do
  #   { game, tally(game)}
  # end

  #This function is executed IF ONLY IF the state is NOT :won or :lost
  def make_move(game, guess) do
    accept_guess(game, guess, MapSet.member?(game.used,guess))
    |> return_with_tally()
  end

  #this function is executed when you pass true as a parameter
  # and is for evaluating if the letter was already used.
  # Then, when MapSet.member be true, mesans the letter was already used.
  defp accept_guess(game, _guess, true) do
    #Generate a new map based on the current game but we use :already_used as state
    %{ game | game_state: :already_used}
  end

  defp accept_guess(game, guess, false) do
    # Generate a new map based on the current game but we add the letter (guess)
    # to the used letter in the game
    %{ game | used: MapSet.put(game.used, guess)}
    |> score_guess(Enum.member?(game.letters, guess))
  end
  #If we have a good guess, this function will be executed
  defp score_guess(game, true) do
    # If we guessed all letter, the game is won else is a good guess
    new_state = maybe_won(MapSet.subset?(MapSet.new(game.letters), game.used))
    %{ game | game_state: new_state }
  end

  # This function is executed when turns left is equal 1
  defp score_guess(game = %{ turns_left: 1 }, false) do
    %{ game | game_state: :lost, turns_left: 0}
  end
  # This function is executed when turns_left is different to 1
  defp score_guess(game, false) do
    %{ game | game_state: :bad_guess, turns_left: game.turns_left - 1 }
  end



  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess




  #
  defp return_with_tally(game) do
    {game, tally(game)}
  end

  def tally(game) do
     %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_guessed_letters(game),
      used: game.used |> MapSet.to_list |> Enum.sort()
    }
  end

  defp reveal_guessed_letters(game)do
    game.letters
    |> Enum.map(fn letter -> MapSet.member?(game.used, letter) |> maybe_reveal(letter) end )
  end
  defp maybe_reveal(true, letter), do: letter
  defp maybe_reveal(false, _letter), do: "_"

end
