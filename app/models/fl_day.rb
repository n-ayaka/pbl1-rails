class FlDay < ApplicationRecord
	self.table_name = 'fl_days'
	self.primary_key = 'school_year'
	has_many :users, foreign_key: :school_year, primary_key: :school_year
end
