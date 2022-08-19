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
  test "New game returns each letters is lowercase" do
    game = Game.new_game()
    assert Enum.join(game.letters) == String.downcase(Enum.join(game.letters))
  end
  test "state doesn't change if a game is won or lost" do
    for state <- [:won, :lost]  do
      game = Game.new_game("Anais")
      game = Map.put(game, :game_state, state)
      { new_game, _tally } = Game.make_move(game, "x")
      assert new_game == game
    end
  end

  test "state doesn't change if a game is won" do
    game = Game.new_game("Anais")
    game = Map.put(game, :game_state, :won)
    { new_game, _tally } = Game.make_move(game, "x")
    assert new_game == game
  end

  test "state doesn't change if a game is lost" do
    game = Game.new_game("Anais")
    game = Map.put(game, :game_state, :lost)
    { new_game, _tally } = Game.make_move(game, "x")
    assert new_game == game
  end

  test "a duplicate letter is reported" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end
  test "a record letters used" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "y")
    {game, _tally} = Game.make_move(game, "x")
    assert MapSet.equal?(game.used, MapSet.new(["x", "y"]))
  end


end
