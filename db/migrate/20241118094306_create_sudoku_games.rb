class CreateSudokuGames < ActiveRecord::Migration[8.0]
  def change
    create_table :sudoku_games do |t|
      t.json :user_board, null: false, default: []
      t.json :win_board, null: false, default: []
      t.json :initial_board, null: false, default: []
      t.string :status, default: "in_progress"
      t.timestamps
    end
  end
end
