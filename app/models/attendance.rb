class Attendance < ApplicationRecord
	self.table_name = 'attendances'
	self.primary_key = 'att_id'
	enum status:{出席:0,遅刻:1,欠席:2,就活:3,病欠:4,公欠:5,要確認:6}
	belongs_to :user, foreign_key: :id
	belongs_to :school_day, foreign_key: :date
end
