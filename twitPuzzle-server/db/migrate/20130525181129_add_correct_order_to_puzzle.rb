class AddCorrectOrderToPuzzle < ActiveRecord::Migration
  def change
    add_column :puzzles, :correct_order, :string
  end
end
