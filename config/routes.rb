Rails.application.routes.draw do
  get "home/index", as: "home"

  root to: "home#index"
  get "about", to: "home#about", as: "about"

  # Pexeso game routes
  get "pexeso", to: "pexeso#index", as: "pexeso"
  resources :pexeso, only: [ :index ] do
    post :flip_card, on: :collection
    post :check_match, on: :collection
    post :reset_game, on: :collection
    post :save_game, on: :collection
    post :load_game, on: :collection
  end

  # Hangman game routes
  get "hangman", to: "hangman#index", as: "hangman"
  post "hangman/guess", to: "hangman#guess", as: "guess"
  post "hangman/reset_game", to: "hangman#reset_game"
  post "hangman/save_game", to: "hangman#save_game"
  post "hangman/load_game", to: "hangman#load_game"

  # Sudoku game routes
  get "sudoku", to: "sudoku#index", as: "sudoku"
  post "sudoku/check_move", to: "sudoku#check_move", as: "check_move"
  post "sudoku/reset_game", to: "sudoku#reset_game"
  get "sudoku/hint", to: "sudoku#hint", as: "sudoku_hint"
  post "sudoku/clear_user_guess", to: "sudoku#clear_user_guess"
  post "sudoku/save_game", to: "sudoku#save_game"
  post "sudoku/load_game", to: "sudoku#load_game"

  # Minesweeper game routes
  get "minesweeper", to: "minesweeper#index", as: "minesweeper"
  post "minesweeper/round_mine", to: "minesweeper#round_mine", as: "round_mine"
  post "minesweeper/reset_game", to: "minesweeper#reset_game"
  post "minesweeper/save_game", to: "minesweeper#save_game"
  post "minesweeper/load_game", to: "minesweeper#load_game"

  resources :scores, only: [ :index, :create, :update ]
  resources :saved_games, only: [ :index, :create, :show ]

  devise_for :users, controllers: {
        sessions: "users/sessions"
      }
end
