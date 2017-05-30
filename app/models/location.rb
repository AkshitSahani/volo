class Location < ApplicationRecord
  belongs_to :organization
  has_many :residents
  has_and_belongs_to_many :volunteers
  has_many :surveys
end
