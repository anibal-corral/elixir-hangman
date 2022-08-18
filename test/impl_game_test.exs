defmodule HangmanImplGameTest do
  use ExUnit.Case
alias Hangman.Impl.Game

  test "New game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "New game returns correct word" do
    game = Game.new_game("Anais")

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["A", "n", "a", "i", "s"]
  end
end
