class Booking < ApplicationRecord
  validates :name, presence: true, length: { minimum: 4, maximum: 32}
  validates :start_time, presence: true, allow_nil: false
  validates :end_time, presence: true, allow_nil: false

  validate :no_overlapping_bookings

  belongs_to :room

  def no_overlapping_bookings
    overlaps = Booking.where('start_time <= ? AND end_time >= ?', end_time, start_time)
    return if overlaps.empty?
    return if overlaps.count == 1 && overlaps.first.id == id
    errors.add(:start_time, "This booking overlaps others")
  end

  def self.status?
    status = false
    Booking.all.each do |booking|
      status = true if booking.start_time <= DateTime.now && DateTime.now <= booking.end_time
    end
    status
  end
end
