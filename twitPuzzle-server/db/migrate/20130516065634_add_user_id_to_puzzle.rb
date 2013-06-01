class AddUserIdToPuzzle < ActiveRecord::Migration
  def change
    add_reference :puzzles, :user, index: true
  end
end
