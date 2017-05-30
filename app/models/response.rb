class Response < ApplicationRecord
  belongs_to :question
  belongs_to :resident, optional: true
  belongs_to :volunteer, optional: true
end
