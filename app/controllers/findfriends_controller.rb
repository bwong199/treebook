class FindfriendsController < ApplicationController
	respond_to :html, :json, :js
	def index



		@users = User.all

	end 



end
