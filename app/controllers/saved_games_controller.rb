class SavedGamesController < ApplicationController
  before_action :authenticate_user!

  def index
    @saved_games = current_user.saved_games
  end

  def create
    @saved_game = current_user.saved_games.find_or_initialize_by(game_name: saved_game_params[:game_name])

    @saved_game.game_state = saved_game_params[:game_state]

    if @saved_game.save
      redirect_to saved_games_path, notice: "Your game has been saved!"
    else
      redirect_to saved_games_path, alert: "Failed to save the game."
    end
  end

  def show
    @saved_game = current_user.saved_games.find_by(game_name: params[:game_name])

    if @saved_game
      @game_state = @saved_game.game_state
    else
      redirect_to games_path, alert: "No saved game found for this game."
    end
  end

  private

  def saved_game_params
    params.require(:saved_game).permit(:game_name, :game_state)
  end
end
