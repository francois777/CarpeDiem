class Chalet < ActiveRecord::Base

  has_many :rented_facilities, as: :rentable

  STYLE_CLASSES = I18n.t(:style_classes).each_with_index.map { |iType| iType[0].to_s }
  CHALET_NAMES = I18n.t(:chalet_names).each_with_index.map { |iType| iType[0].to_s }

  validates :name, presence: true, 
                    length: { minimum: 3, maximum: 20 }
  validates_uniqueness_of :name
  validates :location_code, presence: true, 
                    length: { minimum: 2, maximum: 5 }
  validates_uniqueness_of :location_code

  enum style_class: STYLE_CLASSES

  def camping_type
    'L'
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