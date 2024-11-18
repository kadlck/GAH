class ScoresController < ApplicationController
  before_action :authenticate_user!

  def index
    @scores = current_user.scores
  end

  def create
    @score = current_user.scores.find_or_initialize_by(game_name: score_params[:game_name])
    @score.score = @score.new_record? ? 0 : @score.score + 1

    if @score.save
      redirect_to scores_path, notice: "Your score has been updated!"
    else
      redirect_to scores_path, alert: "Failed to update the score."
    end
  end

  private

  def score_params
    params.require(:score).permit(:game_name)
  end
end
