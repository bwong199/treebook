class FindfriendsController < ApplicationController
	respond_to :html, :json, :js

	def index
		@users = User.order('created_at desc').where.not(id: current_user.user_friendships.map(&:friend_id).uniq).where.not(id: current_user.id)
	end 



end
