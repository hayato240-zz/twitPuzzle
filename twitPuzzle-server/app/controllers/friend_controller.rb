class FriendController < ApplicationController
  def index
  	@users = User.all
  	@friend = Friend.new
  	@friends_list = Friend.where("user_id = #{session[:login]}")
  end

  def create
  	@friend = Friend.new(user_id: session[:login], friend_id: params[:friend][:friend_id])
    @friend.save
    redirect_to friend_index_path
  end

  def destroy
    Friend.delete_all("user_id = #{session[:login]} and friend_id= #{params[:friend][:friend_id]}")
#    @friend.save
#    Friend.delete(params[:id])
    redirect_to friend_index_path
  end

  def follow
    follow_users = Friend.where("user_id=#{session[:login]}")
    @follows = []

    for follow in follow_users
      @user = User.find(follow.friend_id)
      @follows.push(:id=>follow.friend_id, :name=> @user.name, :friendState=>"iii")
    end
  end

  def follower
    puts "session::",session[:login]
    follower_users = Friend.where("friend_id=#{session[:login]}")

    @followers = []
    for follower in follower_users
      puts "2222222222222222222222"
      f = Friend.where("user_id=#{session[:login]} and friend_id=#{follower.user_id}")
      if f.size>0
        friendState = "アンフォロー"
      else
        friendState = "フォロー"
      end
      @user = User.find(follower.user_id)
      @followers.push(:id=>follower.user_id, :name=>@user.name, :friendState=>friendState)
    end
  end

  private
  def friend_params
    params.require(:friendships).permit(:friend_id)
  end
end
