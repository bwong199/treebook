class ActivitiesController < ApplicationController
respond_to :html, :json

  def index
    friend_ids = current_user.user_friendships.map(&:friend_id)
    @activities = Activity.where("user_id in (?)", friend_ids.push(current_user.id)).order("created_at desc").all
  	respond_with @activities

  end
end
