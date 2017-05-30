class Question < ApplicationRecord
  has_many :responses
  belongs_to :survey
end
