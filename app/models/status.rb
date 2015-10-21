class Status < ActiveRecord::Base
	belongs_to :user
	belongs_to :document
	has_many :comments
	has_many :likes

	accepts_nested_attributes_for :document


	validates :content, presence: true, length: {minimum: 2}
	validates :user_id, presence: true
end
