class CreateSavedGames < ActiveRecord::Migration[8.0]
  def change
    create_table :saved_games do |t|
      t.references :user, null: false, foreign_key: true
      t.string :game_name
      t.text :game_state

      t.timestamps
    end
    add_index :saved_games, [ :user_id, :game_name ], unique: true
  end
end
