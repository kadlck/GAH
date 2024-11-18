class MinesweeperController < ApplicationController
  before_action :initialize_game, only: [ :index, :round_mine ]

  def index
  end

  def round_mine
    row = params["row"].to_i
    col = params["col"].to_i
    user_move = [ row, col ]

    if session[:mines].include?(user_move)
      flash[:notice] = "💥 BOOM! You hit a mine!"
      session[:guesses] = []
      session[:end] = true
    else
      reveal_cells(row, col)
      flash[:notice] = "WOW. Missed the mine!"
    end


    redirect_to minesweeper_path
  end

  def reveal_cells(row, col)
    return if row < 0 || row >= 9 || col < 0 || col >= 9
    return if session[:guesses].any? { |guess| guess["row"] == row && guess["col"] == col }
    mine_count = count_mines(row, col)
    session[:guesses] << { "row" => row, "col" =>  col, "value" => mine_count }
    if mine_count == 0
      directions = [
        [ 1, 0 ], [ -1, 0 ], [ 0, 1 ], [ 0, -1 ],
        [ 1, 1 ], [ -1, -1 ], [ 1, -1 ], [ -1, 1 ]
      ]
      directions.each do |dx, dy|
        reveal_cells(row + dx, col + dy)
      end
    end
  end

  def reset_game
    session[:guesses] = []
    session[:mines] = []
    session[:end] = false
    where = params["where"]

    if where == "STAY"
      redirect_to minesweeper_path
    else
      redirect_to home_path
    end
  end


  def save_game
    saved_game = SavedGame.find_or_initialize_by(user: current_user, game_name: "Minesweeper")

    game_state = {
      guesses: session[:guesses],
      mines: session[:mines],
      end: session[:end]
    }
    saved_game.update(game_state: game_state.to_json)
    flash[:notice] = "Game saved successfully!"
    redirect_to minesweeper_path
  end

  def load_game
    saved_game = SavedGame.find_by(user: current_user, game_name: "Minesweeper")
    if saved_game
      unpacked_game_state = JSON.parse(saved_game.game_state)
      puts unpacked_game_state
      session[:mines] = unpacked_game_state["mines"]
      session[:guesses] = unpacked_game_state["guesses"]
      session[:end] = unpacked_game_state["end"]
      flash[:notice] = "Game loaded successfully!"
    else
      flash[:alert] = "No saved game found."
    end

    redirect_to minesweeper_path
  end

  private

  def initialize_game
    if session[:mines].nil? || session[:mines].empty?
      generate_mines
      session[:guesses] = []
      session[:end] = false
    end
  end

  def generate_mines
    session[:mines] = []
    9.times do |row|
      9.times do |col|
        session[:mines] << [ row, col ] if rand < 0.5
      end
    end
  end

  def count_mines(row, col)
    directions = [
      [ 1, 0 ], [ -1, 0 ], [ 0, 1 ], [ 0, -1 ],
      [ 1, 1 ], [ -1, -1 ], [ 1, -1 ], [ -1, 1 ]
    ]
    directions.count do |(dx, dy)|
      new_row, new_col = row + dx, col + dy
      next false if new_row < 0 || new_row >= 9 || new_col < 0 || new_col >= 9
      session[:mines].include?([ new_row, new_col ])
    end
  end
end
