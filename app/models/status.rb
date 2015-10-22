class Status < ActiveRecord::Base
	belongs_to :user
	belongs_to :document
	has_many :comments, dependent: :destroy
	has_many :likes, dependent: :destroy

	accepts_nested_attributes_for :document


	validates :content, presence: true, length: {minimum: 2}
	validates :user_id, presence: true
end
