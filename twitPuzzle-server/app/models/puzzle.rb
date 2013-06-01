class Puzzle < ActiveRecord::Base
	  belongs_to :user

	  def self.follow_timeline(user_id)
	  	puts "userID::",user_id
  		friends = Friend.where(user_id: user_id)
	  	num = friends.map{ |f|f.friend_id} 
	  	num.append(user_id)
	  	t = Puzzle.where("user_id in (?) ", num )
	    return t.sort{|a,b| b.created_at <=> a.created_at }
	  end

end

