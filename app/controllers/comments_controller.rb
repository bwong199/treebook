class CommentsController < ApplicationController
	def index
		
	end

	def create
		# @status = Status.find(params[:status_id])
		# @user = User.find(params[:user_id])
		@comment = Comment.new(content: comment_params[:content], status_id: params[:status_id], user_id: params[:user_id])
		@comment.save
		current_user.create_activity(@comment, 'created')
		redirect_to statuses_path
		flash[:success] =  "Comment created" 
	end 

	def show
	@comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
	end

	private 
  	def comment_params
  		params.require(:comment).permit(:content, :user_id)
 	end

end
