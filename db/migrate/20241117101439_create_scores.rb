class CreateScores < ActiveRecord::Migration[8.0]
  def change
    create_table :scores do |t|
      t.references :user, null: false, foreign_key: true
      t.string :game_name
      t.integer :score

      t.timestamps
    end
  end
end
