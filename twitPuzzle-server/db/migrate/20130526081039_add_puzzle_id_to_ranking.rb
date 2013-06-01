class AddPuzzleIdToRanking < ActiveRecord::Migration
  def change
    add_reference :rankings, :puzzle, index: true
  end
end
