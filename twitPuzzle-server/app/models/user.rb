class User < ActiveRecord::Base
	has_many :puzzles 
	has_many :rankings
	validates_uniqueness_of(:name)
  validates_uniqueness_of(:email)
  validates_presence_of :name, :email, :password

	def registered?
		user_obj = User.where(email: self.email).first
		if user_obj && user_obj.password == self.password
			self.id = user_obj.id
			true
		else	
			false
		end
	end
end
