require 'action_view'
require 'action_view/helpers'

class Cat < ApplicationRecord
  include ActionView::Helpers::DateHelper

  COLORS = %w[black white grey ginger blue brown calico].freeze

  validates :birth_date, :name, :description, presence: true
  validates :color, inclusion: { in: COLORS, message: "%{value} is not a valid color" }
  validates :sex, inclusion: { in: %w[M F], message: 'Must be M or F' }

  belongs_to :owner,
    class_name: 'User',
    primary_key: :id,
    foreign_key: :user_id

  has_many :cat_rental_requests,
    dependent: :destroy

  def age
    time_ago_in_words(self.birth_date)
  end
end