class AddUserIdToRanking < ActiveRecord::Migration
  def change
    add_reference :rankings, :user, index: true
  end
end
