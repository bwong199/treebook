class FindfriendsController < ApplicationController
	respond_to :html, :json, :js

	def index
		@users = User.where.not(id: current_user.user_friendships.map(&:friend_id).uniq).where.not(id: current_user.id)
	end 



end
