class CatRentalRequest < ApplicationRecord
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: %w[PENDING APPROVED DENIED], message: 'Must be PENDING, APPROVED or DENIED' }

  belongs_to :cat
end