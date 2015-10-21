class LikesController < ApplicationController
	def create

		@like = Like.new(status_id: params[:status_id], user_id: params[:user_id], comment_id: params[:comment_id])
		@like.save
		current_user.create_activity(@like, 'created')
		redirect_to statuses_path
		flash[:success] =  "You liked this" 

	end 


	def show 
    @like= Like.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @like }
    end

	end 
end
