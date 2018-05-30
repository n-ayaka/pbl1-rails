class User < ApplicationRecord
	self.table_name = 'users'
	self.primary_key = 'uid'
	has_many :attendances, foreign_key: :uid, primary_key: :uid
	has_many :images, foreign_key: :uid, primary_key: :uid
	has_many :histories, foreign_key: :uid, primary_key: :uid
	belongs_to :fl_day, foreign_key: :school_year, optional: true
end
