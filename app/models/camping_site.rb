class CampingSite < ActiveRecord::Base

  has_many :rented_facilities, as: :rentable
  validates :location_code, presence: true, 
                    length: { minimum: 2, maximum: 5 }
  validates_uniqueness_of :location_code

  validates :camping_type, inclusion: { in: ['C', 'T'] }

  default_scope { order('camping_type, location_code') }
  scope :reservable, -> { where('reservable = ?', true) }
  scope :tents, -> { where('camping_type = ?', 'T') }
  scope :caravans, -> { where('camping_type = ?', 'C') }

  def self.available_tents_between(start_date, end_date)
    site_count = 0 
    CampingSite.all.each do |site|
      site_count += 1 if site.available_between?(start_date, end_date)
    end
    site_count
  end

  def available_between?(start_date, end_date)
    return true if start_date > end_date
    day_first = start_date.to_datetime
    day_last = end_date.to_datetime
    reserved = false
    rented_facilities.each do |period|
      period_start = period.start_date.to_datetime
      period_end = period.end_date.to_datetime
      next if period_start >= day_last
      break if period_end <= day_first 
      while day_first <= day_last
        next if day_first == period_end
        if day_first >= period_start && day_first < period_end
          reserved = true
          break
        end  
        day_first += 1 
      end
    end  
    !reserved
  end
end
