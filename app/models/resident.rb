class Resident < ApplicationRecord
  belongs_to :location
  has_many :responses
  has_many :matches
end
