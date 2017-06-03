class Question < ApplicationRecord
  has_many :responses
  has_many :answer_sets, inverse_of: :question
  belongs_to :survey

  accepts_nested_attributes_for :answer_sets, reject_if: :all_blank, allow_destroy: true
end
