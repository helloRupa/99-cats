class CatRentalRequest < ApplicationRecord
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: %w[PENDING APPROVED DENIED], message: 'Must be PENDING, APPROVED or DENIED' }
  validate :valid_dates
  validate :does_not_overlap_approved_request

  belongs_to :cat

  def valid_dates
    valid = self.start_date >= Date.current && self.start_date <= self.end_date
    msg = 'Dates must be today or in the future, start date must be earlier or same as end date'
    errors.add(:start_date, :end_date, message: msg) unless valid
  end
  
  def overlapping_requests
    CatRentalRequest.where(cat_id: self.cat_id)
      .where.not(id: self.id)
      .where.not('start_date > ? AND start_date > ? OR end_date < ?', self.start_date, self.end_date, self.start_date)
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: 'APPROVED')
  end

  def does_not_overlap_approved_request
    errors.add(:start_date, :end_date, message: 'Cat unavailable on those dates') if overlapping_approved_requests.exists?
  end
end