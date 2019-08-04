class HotelPlan < ApplicationRecord
  validates :plan_name, presence: true
  validates :room_name, presence: true, uniqueness: { scope: :plan_name }
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
