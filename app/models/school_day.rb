class SchoolDay < ApplicationRecord
	self.table_name = 'school_days'
	self.primary_key = 'date'
	has_many :attendances, foreign_key: :date, primary_key: :date, dependent: :destroy
end
