class AddImageToPuzzle < ActiveRecord::Migration
  def change
    add_column :puzzles, :image, :binary
  end
end
