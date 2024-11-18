class PexesoController < ApplicationController
  before_action :set_game, only: [ :index, :flip_card, :check_match ]

  def index
    @theme = params[:theme] || session[:theme] || "cats"
    session[:theme] = @theme
  end

  def flip_card
    card = @game.cards.find_by(position: params[:position].to_i)
    if card && !card.flip_state && !card.found
      card.flip!
      session[:flipped_cards] ||= []
      session[:flipped_cards] << card.card_id
    end
    puts session[:flipped_cards]
    if session[:flipped_cards].length >= 2
      redirect_to pexeso_path (session[:show_flipped] = true)
    else
      redirect_to pexeso_path
    end
  end

  def check_match
    flipped_cards = @game.cards.where(card_id: session[:flipped_cards])
    if flipped_cards.length == 2 && flipped_cards[0].card_id == flipped_cards[1].card_id
      flipped_cards.each(&:match!)
      flash[:notice] = "It's a match!"
    else
      flipped_cards.each { |card| card.flip_back! }
      flash[:alert] = "Not a match, try again!"
    end

    session[:flipped_cards] = nil
    if @game.cards.all?(&:found?)
      @game.update(status: :completed)
      current_user.increase_score("Pexeso") if current_user
      flash[:notice] = "Congratulations, you won!"
    end

    shuffle_cards
    redirect_to pexeso_path
  end

  def reset_game
    where = params["where"]
    session[:game_iden] = nil if session[:game_iden]
    session[:flipped_cards] = []
    if where == "STAY"
      redirect_to pexeso_path
    else
      redirect_to home_path
    end
  end

  def save_game
    saved_game = SavedGame.find_or_initialize_by(user: current_user, game_name: "Pexeso")

    game_state = {
      game_iden: session[:game_iden]
    }
    saved_game.update(game_state: game_state.to_json)
    flash[:notice] = "Game saved successfully!"
    redirect_to pexeso_path
  end

  def load_game
    saved_game = SavedGame.find_by(user: current_user, game_name: "Pexeso")
    if saved_game
      unpacked_game_state = JSON.parse(saved_game.game_state)
      session[:game_iden] = unpacked_game_state["game_iden"]
      flash[:notice] = "Game loaded successfully!"
    else
      flash[:alert] = "No saved game found."
    end

    redirect_to pexeso_path
  end


  private

  def shuffle_cards
    to_shuffle = @game.cards.where(flip_state: false, found: false)
    old_positions = []
    to_shuffle.each { |card| old_positions << card[:position] }
    puts old_positions
    new_positions = old_positions.shuffle
    to_shuffle.each_with_index do |card, index|
      card.update(position: new_positions[index])
    end
  end

  def set_game
    if session[:game_iden].nil?
      iden = SecureRandom.hex(8)
      @game = Game.create(iden: iden, status: :in_progress)
      session[:game_iden] = @game.id
    else
      @game = Game.find(session[:game_iden])
    end
  end
end
