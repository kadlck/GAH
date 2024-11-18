Rails.application.routes.draw do
  root to: "home#index"
  get "about", to: "home#about", as: "about"
  get "home/index"

  # Pexeso game routes
  resources :pexeso, only: [ :index ] do
    post :flip_card, on: :collection
    post :check_match, on: :collection
    post :reset_game, on: :collection
    post :save_game, on: :collection
    post :load_game, on: :collection
  end

  # Hangman game routes
  resources :hangman, only: [ :index ] do
    post :guess, on: :collection
    post :reset_game, on: :collection
    post :save_game, on: :collection
    post :load_game, on: :collection
  end

  # Sudoku game routes
  resources :sudoku, only: [ :index ] do
    post :check_move, on: :collection
    get :hint, on: :collection
    post :clear_user_guess, on: :collection
    post :reset_game, on: :collection
    post :save_game, on: :collection
    post :load_game, on: :collection
  end

  # Minesweeper game routes
  resources :minesweeper, only: [ :index ] do
    post :round_mine, on: :collection
    post :reset_game, on: :collection
    post :save_game, on: :collection
    post :load_game, on: :collection
  end

  resources :scores, only: [ :index, :create, :update ]
  resources :saved_games, only: [ :index, :create, :show ]

  devise_for :users, controllers: {
        sessions: "users/sessions"
      }
end
