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

	def edit
    	@comment = Comment.find(params[:id])
	end 

	def show
	@comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
	end

  	def update

	    @comment = current_user.comments.find(params[:id])

	    @comment.update(comment_params)

	    current_user.create_activity(@comment, 'updated')

	    redirect_to statuses_path


    end 

  	def destroy
	    @comment = Comment.find(params[:id])
	    @comment.destroy
	    respond_to do |format|
	      format.html { redirect_to statuses_path, notice: 'Comment was successfully destroyed.' }
	      format.json { head :no_content }
	    end
  	end

	private 
  	def comment_params
  		params.require(:comment).permit(:content, :user_id)
 	end



end
