class Organization < ApplicationRecord
  has_many :locations, inverse_of: :organization
  belongs_to :user

  accepts_nested_attributes_for :locations, reject_if: :all_blank, allow_destroy: true
end
