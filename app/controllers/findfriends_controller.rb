class FindfriendsController < ApplicationController
	def index
		@users = User.all
	end 
end
