class User < ApplicationRecord
  has_many :attendances, dependent: :destroy
end
