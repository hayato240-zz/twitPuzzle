class CreatePuzzles < ActiveRecord::Migration
  def change
    create_table :puzzles do |t|
      t.string :tweet

      t.timestamps
    end
  end
end
