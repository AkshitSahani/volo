class Survey < ApplicationRecord
  has_and_belongs_to_many :locations
  has_many :questions, inverse_of: :survey
  has_many :responses, through: :questions
  belongs_to :organization, optional: true 

  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true
end
