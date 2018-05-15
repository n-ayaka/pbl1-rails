class User < ApplicationRecord
	self.table_name = 'users'
	self.primary_key = 'id'
	has_many :attendances, foreign_key: :id, primary_key: :id
	has_many :images, foreign_key: :id, primary_key: :id
	has_many :histories, foreign_key: :id, primary_key: :id
	belongs_to :fl_day, foreign_key: :school_year
end
