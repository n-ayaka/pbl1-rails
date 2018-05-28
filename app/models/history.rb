class History < ApplicationRecord
	self.table_name = 'histories'
	self.primary_key = 'history_id'
	belongs_to :user, foreign_key: :uid
end
