class Attdetail < ApplicationRecord
	self.table_name = 'attdetails'
	self.primary_key = 'detail_id'
	has_many :attendances, foreign_key: :att1, primary_key: :att_id
end
