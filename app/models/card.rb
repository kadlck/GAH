class Card < ApplicationRecord
  belongs_to :game

  def flip!
    update(flip_state: true)
  end

  def flip_back!
    update(flip_state: false)
  end

  def match!
    update(found: true)
  end
end
