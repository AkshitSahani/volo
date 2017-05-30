class Survey < ApplicationRecord
  belongs_to :location
  has_many :questions
  has_many :responses, through: :questions
end
