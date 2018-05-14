class Attendance < ApplicationRecord
	self.table_name = 'attendances'
	self.primary_key = 'att_id'
	belongs_to :user, foreign_key: :id
	belongs_to :attdetail, foreign_key: :att1
end
