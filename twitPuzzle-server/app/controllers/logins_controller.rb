class LoginsController < ApplicationController

  def new
  	@user = User.new()
  end

  def create
  	@user = User.new(user_params)
  	if @user.registered?
  		session[:login] = @user.id
      puts "session1::", session[:login]
      respond_to do |format|
       format.html { redirect_to puzzles_url }
       format.json { render :text => @user.id }
      end
  	else
      respond_to do |format|
         format.html { render action: 'new'}
         format.json { render :text => 'false' }
      end

  	end
  			
  end

  def destroy
  	session[:login] = nil
  	redirect_to new_login_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
