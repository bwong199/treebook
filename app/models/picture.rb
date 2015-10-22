class Picture < ActiveRecord::Base
  belongs_to :album
  belongs_to :user

  has_attached_file :asset, 
  styles: {large: "800x800>", medium: "300x200>", small: "260x180>", thumb:"100x100#"}
validates_attachment :asset, 
content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

	
	def to_s
		caption? ? caption : "Picture"
	end

end
