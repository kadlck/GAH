class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.references :game, null: false, foreign_key: true
      t.integer :card_id
      t.integer :position
      t.boolean :flip_state
      t.boolean :found

      t.timestamps
    end
  end
end
