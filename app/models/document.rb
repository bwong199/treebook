class Document < ActiveRecord::Base
	attr_accessor :remove_attachment


	has_attached_file :attachment
	validates_attachment :attachment, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

	before_save :performn_attachment_removal

	def performn_attachment_removal
		if remove_attachment == '1' && !attachment.dirty?
			self.attachment = nil
		end
	end

end
