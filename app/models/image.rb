class Image < ApplicationRecord
	self.table_name = 'images'
	self.primary_key = 'image_id'
	belongs_to :user, foreign_key: :id
end
