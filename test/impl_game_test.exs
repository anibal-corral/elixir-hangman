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

  test "we recognize a letter in the word" do
    game = Game.new_game("anais")
    { _game, tally} = Game.make_move(game, "a")
    assert tally.game_state == :good_guess
    { _game, tally} = Game.make_move(game, "i")
    assert tally.game_state == :good_guess

  end
  test "we recognize a letter NOT in the word" do
    game = Game.new_game("anais")
    { _game, tally} = Game.make_move(game, "a")
    assert tally.game_state == :good_guess
    { _game, tally} = Game.make_move(game, "b")
    assert tally.game_state == :bad_guess

  end

  test "we recognize a entire word" do
    #word is anais
    game = Game.new_game("anais")
    #we guess with letter a
    { _game, tally } =  Game.make_move(game, "a")
    #the game is like this: [guess, state,      turns_left, letters,                    used]
    #the game is like this: ["a",   :good_guess, 6,         ["a", "_", "a", "_", "_"], ["a"]]
    { _game, tally } =  Game.make_move(game, "c")
    #the game is like this: ["c",   :bad_guess, 5,         ["a", "_", "a", "_", "_"], ["a","b"]]
    { _game, tally } =  Game.make_move(game, "n")
    #the game is like this: ["n",   :good_guess, 5,         ["a", "n", "a", "_", "_"], ["a","b","n"]]
    { _game, tally } =  Game.make_move(game, "s")
    #the game is like this: ["s",   :good_guess, 5,         ["a", "n", "a", "_", "s"], ["a","b","n","s"]]
    { _game, tally } =  Game.make_move(game, "d")
    #the game is like this: ["d",   :bad_guess, 4,         ["a", "n", "a", "_", "s"], ["a","b","n","s","d"]]
    { _game, tally } =  Game.make_move(game, "e")
    #the game is like this: ["e",   :bad_guess, 3,         ["a", "n", "a", "_", "s"], ["a","b","n","s","d","e"]]
    { _game, tally } =  Game.make_move(game, "a")
    #the game is like this: ["a",   :already_used, 5,         ["a", "n", "a", "_", "s"], ["a","b","n","s"]]
    { _game, tally } =  Game.make_move(game, "i")
    #the game is like this: ["i",   :good_guess, 3,         ["a", "n", "a", "i", "s"], ["a","b","n","s","d","e","i"]]

  end
  ##Same like above but using a function
  test "we recognize a entire word version 2" do
    #word is anais
    [
      ["a",   :good_guess, 7,         ["a", "_", "a", "_", "_"], ["a"]],
      ["c",   :bad_guess, 6,         ["a", "_", "a", "_", "_"], ["a","c"]] ,
      ["n",   :good_guess, 6,         ["a", "n", "a", "_", "_"], ["a","c","n"]],
      ["s",   :good_guess, 6,         ["a", "n", "a", "_", "s"], ["a","c","n","s"]],
      ["d",   :bad_guess, 5,         ["a", "n", "a", "_", "s"], ["a","c","d","n","s"]],
      ["e",   :bad_guess, 4,         ["a", "n", "a", "_", "s"], ["a","c","d","e","n","s"]],
      ["a",   :already_used, 4,         ["a", "n", "a", "_", "s"], ["a","c","d","e","n","s"]],
      ["i",   :won, 4,         ["a", "n", "a", "i", "s"], ["a","c","d","e","i","n","s"]]
    ]
    |> test_sequence_of_move()
  end

  test "we can handle a losing game" do
    #word is anais
    [
      ["b",   :bad_guess, 6,         ["_", "_", "_", "_", "_"], ["b"]],
      ["d",   :bad_guess, 5,         ["_", "_", "_", "_", "_"], ["b","d"]] ,
      ["e",   :bad_guess, 4,         ["_", "_", "_", "_", "_"], ["b","d","e"]],
      ["f",   :bad_guess, 3,         ["_", "_", "_", "_", "_"], ["b","d","e","f"]],
      ["g",   :bad_guess, 2,         ["_", "_", "_", "_", "_"], ["b","d","e","f","g"]],
      ["h",   :bad_guess, 1,         ["_", "_", "_", "_", "_"], ["b","d","e","f","g","h"]],
      ["j",   :lost, 0,              ["a", "n", "a", "i", "s"], ["b","d","e","f","g","h","j"]],

    ]
    |> test_sequence_of_move()
  end

  defp test_sequence_of_move(script)do
    game = Game.new_game("anais")
    Enum.reduce(script, game, &check_one_move/2)
  end

  defp check_one_move([ guess, state, turns_left, letters, used ], game) do
    { game, tally } = Game.make_move(game, guess)
    assert tally.game_state == state
    assert tally.turns_left == turns_left
    assert tally.letters == letters
    assert tally.used == used

    game
  end

end
