class HangmanController < ApplicationController
  before_action :initialize_game, only: [ :index, :guess ]

  def index
  end

  def guess
    letter = params["letter"]
    if session[:incorrect_guesses] >= 6
      reset_game
    end

    if session[:secret_word].include?(letter)
      session[:good_letters].push letter
    else
      session[:guessed_letters].push letter
      session[:incorrect_guesses] += 1
    end

    if session[:secret_word].uniq.sort == session[:good_letters].sort
      current_user.increase_score("Hangman") if current_user
      flash[:notice] = "You won! Your score has been updated."
    end

    redirect_to hangman_path
  end

  def save_game
    saved_game = SavedGame.find_or_initialize_by(user: current_user, game_name: "Hangman")

    game_state = {
      secret_word: session[:secret_word],
      good_letters: session[:good_letters],
      incorrect_guesses: session[:incorrect_guesses],
      guessed_letters: session[:guessed_letters]
    }
    saved_game.update(game_state: game_state.to_json)
    flash[:notice] = "Game saved successfully!"
    redirect_to hangman_path
  end

  def load_game
    saved_game = SavedGame.find_by(user: current_user, game_name: "Hangman")
    if saved_game
      unpacked_game_state = JSON.parse(saved_game.game_state)
      puts unpacked_game_state
      session[:secret_word] = unpacked_game_state["secret_word"]
      session[:good_letters] = unpacked_game_state["good_letters"]
      session[:incorrect_guesses] = unpacked_game_state["incorrect_guesses"]
      session[:guessed_letters] = unpacked_game_state["guessed_letters"]

      flash[:notice] = "Game loaded successfully!"
    else
      flash[:alert] = "No saved game found."
    end

    redirect_to hangman_path
  end

  def reset_game
    where = params["where"]
    session[:secret_word] = nil
    session[:good_letters] = []
    session[:incorrect_guesses] = nil
    session[:guessed_letters] = []
    if where == "STAY"
      redirect_to hangman_path
    else
      redirect_to home_path
    end
  end

  private
  def initialize_game
    if session[:secret_word].nil?
      choose_word
      session[:incorrect_guesses] = 0
      session[:good_letters] = []
      session[:guessed_letters] = []
    end
  end

  def choose_word
    words = []
    file_of_words_path = Rails.root.join("app", "assets", "hangman", "words.txt")
    words = File.readlines(file_of_words_path).map(&:strip)
    session[:secret_word] = words.sample.split("")
  end
end
