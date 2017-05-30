class Volunteer < ApplicationRecord
  has_and_belongs_to_many :locations
  has_many :responses
  has_many :matches
  belongs_to :user
end
