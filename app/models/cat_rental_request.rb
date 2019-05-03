class CatRentalRequest < ApplicationRecord
  validates :status, inclusion: { in: %w[PENDING APPROVED DENIED], message: 'Must be PENDING, APPROVED or DENIED' }
  validate :valid_dates, on: :create
  validate :does_not_overlap_approved_request, on: :create

  belongs_to :cat
  belongs_to :user
  
  def approve!
    raise 'Not Pending' unless pending?

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

  def self.cancel_expired_requests
    expired = CatRentalRequest.where('start_date < ? AND status = ?', Date.current, 'PENDING')

    expired.each { |req| req.deny! }
  end

  private

  def pending?
    self.status == 'PENDING'
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

  def deny_overlapping!
    overlapping_pending_requests.each do |req|
      req.status = 'DENIED'
      req.save!
    end
  end

  def valid_dates
    valid = !self.start_date.nil? && !self.end_date.nil? && self.start_date >= Date.current && self.start_date <= self.end_date
    msg = 'Dates must be today or in the future'
    errors.add(:start_date, message: msg) unless valid
  end

  def does_not_overlap_approved_request
    return unless pending?

    errors.add(:start_date, message: 'Cat unavailable on those dates') if overlapping_approved_requests.exists?
  end
end
