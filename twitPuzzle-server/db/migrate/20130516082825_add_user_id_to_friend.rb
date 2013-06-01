class AddUserIdToFriend < ActiveRecord::Migration
  def change
    add_reference :friends, :user, index: true
  end
end
