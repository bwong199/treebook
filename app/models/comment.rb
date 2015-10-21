class Comment < ActiveRecord::Base
  belongs_to :status
  belongs_to :user
  has_many :likes
  validates :content, presence: true, length: {minimum: 2}
end
