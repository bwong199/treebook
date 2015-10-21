class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :status
  belongs_to :comment
  belongs_to :picture
end
