class Game < ApplicationRecord
  has_many :cards

  enum :status, { in_progress: "in_progress", completed: "completed" }

  after_create :initialize_game

  private

  def initialize_game
    card_ids = (1..8).to_a * 2
    card_ids.each_with_index do |card_id, position|
      cards.create(card_id: card_id, position: position, flip_state: false, found: false)
    end
  end
end
