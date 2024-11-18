class User < ApplicationRecord
  has_many :scores
  has_many :saved_games

  def increase_score(game_name)
    score = scores.find_or_initialize_by(game_name: game_name)
    score.score += 1
    score.save
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
