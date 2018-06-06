class SchoolDay < ApplicationRecord
  has_many :attendances, dependent: :destroy
end
