class RemoveFriendIdToFriend < ActiveRecord::Migration
  def change
    remove_column :friends, :friend_id, :string
  end
end
