class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.string :iden
      t.string :status
      t.integer :score

      t.timestamps
    end
  end
end
