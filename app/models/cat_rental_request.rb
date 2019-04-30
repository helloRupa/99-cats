class CatRentalRequest < ApplicationRecord
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: %w[PENDING APPROVED DENIED], message: 'Must be PENDING, APPROVED or DENIED' }
  validate :valid_dates, on: :create
  validate :does_not_overlap_approved_request, on: :create

  belongs_to :cat

  def valid_dates
    valid = !self.start_date.nil? && !self.end_date.nil? && self.start_date >= Date.current && self.start_date <= self.end_date
    msg = 'Dates must be today or in the future'
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

  def overlapping_pending_requests
    overlapping_requests.where(status: 'PENDING')
  end

  def does_not_overlap_approved_request
    errors.add(:start_date, :end_date, message: 'Cat unavailable on those dates') if overlapping_approved_requests.exists?
  end

  def deny_overlapping!
    overlapping_pending_requests.each do |req|
      req.status = 'DENIED'
      req.save!
    end
  end
  
  def approve!
    CatRentalRequest.transaction do
      self.status = 'APPROVED'
      self.save!

      deny_overlapping!
    end
  end

  def deny!
    self.status = 'DENIED'
    self.save
  end
end
