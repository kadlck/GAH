class SudokuController < ApplicationController
  before_action :set_game, only: [ :index, :check_move, :hint, :reset_game, :clear_user_guess ]

  def index
  end

  def check_move
    value = params[:value].to_i
    row = params[:row].to_i
    col = params[:col].to_i

    user_board = @game.user_board
    win_board = @game.win_board

    if win_board[row][col] == value
      user_board[row][col] = value
      @game.update(user_board: user_board)
      flash[:notice] = "Correct move!"
    else
      user_board[row][col] = value
      @game.update(user_board: user_board)
    end

    if user_board.flatten.none?(&:nil?)
      if user_board == win_board
        @game.update(status: "completed")
        current_user.increase_score("Sudoku") if current_user
        flash[:notice] = "Congratulations, you solved the Sudoku!"
      else
        flash[:alert] = "The solution is incorrect. Keep trying!"
      end
    end

    cookies.delete(:hint)
    redirect_to sudoku_path
  end

  def reset_game
    where = params["where"]
    session[:game_id] = nil
    @game.destroy
    if where == "STAY"
      redirect_to pexeso_path
    else
      redirect_to home_path
    end
  end

  def clear_user_guess
    initial_board = @game.initial_board
    @game.update(user_board: initial_board)
    cookies.delete(:hint)
    redirect_to sudoku_path
  end

  def hint
    file_of_hints_path = Rails.root.join("app", "assets", "sudoku", "hints.txt")
    cookies[:hint] = { value: (File.readlines(file_of_hints_path).sample), expires: 1.minute.from_now }
    redirect_to sudoku_path
  end

  def save_game
    saved_game = SavedGame.find_or_initialize_by(user: current_user, game_name: "Sudoku")

    game_state = {
      game_id: session[:game_id]
    }
    saved_game.update(game_state: game_state.to_json)
    flash[:notice] = "Game saved successfully!"
    redirect_to sudoku_path
  end

  def load_game
    saved_game = SavedGame.find_by(user: current_user, game_name: "Sudoku")
    if saved_game
      unpacked_game_state = JSON.parse(saved_game.game_state)
      session[:game_id] = unpacked_game_state["game_id"]
      flash[:notice] = "Game loaded successfully!"
    else
      flash[:alert] = "No saved game found."
    end

    redirect_to sudoku_path
  end

  private

  def set_game
    @game = session[:game_id] ? SudokuGame.find(session[:game_id]) : SudokuGame.create_new_game
    session[:game_id] ||= @game.id
  end
end
