class Survey < ApplicationRecord
  belongs_to :location
  has_many :questions
  has_many :responses, through: :questions

  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true
end
