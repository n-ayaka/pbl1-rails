class Attendance < ApplicationRecord
	self.table_name = 'attendances'
	self.primary_key = 'att_id'
	belongs_to :user, foreign_key: :uid
	belongs_to :school_day, foreign_key: :date
end
