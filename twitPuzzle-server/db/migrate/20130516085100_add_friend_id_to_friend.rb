class AddFriendIdToFriend < ActiveRecord::Migration
  def change
    add_column :friends, :friend_id, :integer
  end
end
