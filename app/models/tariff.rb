class Tariff < ActiveRecord::Base

  has_paper_trail on: [:create, :update, :destroy]

  VALID_TARIFF_CATEGORY = /\A[A-J][1-3]\z/
  TARIFF_CATEGORIES = I18n.t(:tariff_categories, scope: [:activerecord, :attributes, :tariff])
  PRICE_CLASSES = I18n.t(:price_classes, scope: [:activerecord, :attributes, :tariff])

  belongs_to :accommodation_type

  validates :tariff_category, presence: true,
                              format: { with: VALID_TARIFF_CATEGORY },
                              uniqueness: { scope: :effective_date }
  validate :tariff, presence: true
                    
  validates :effective_date, presence: true          
  validate :validate_effective_date_before_end_date
  validate :tariff_cannot_be_zero

  default_scope { order('tariff_category ASC, effective_date DESC') }
  scope :promotions, -> { where('show_promotion = ?', true) }
  scope :no_power, -> { where('with_power_points = ?', false) }  

  enum price_class: [:normal_price, :in_season_price, :special_price]

  def self.adult_price(facility_type, power_point_included, requested_from, requested_until)
    # find accommodation type
    # get applicable tariffs
    # apply tariffs to requested period
    # return price
    
  end


  def self.find_prices(accom_type, requested_from, requested_until)
    results = []
    price_periods = find_period_prices(accom_type, requested_from, requested_until)
    # puts "Periods pulled from DB: #{price_periods.inspect}"

    price_periods.each do |period|
      period_start = period.effective_date
      period_end = period.end_date || Date.today + 1000
      if period.end_date.nil? 
        next if period.effective_date > requested_until
        results << { date_from: period_start, date_until: period_end, tariff: period.tariff }
        break if period.effective_date <= requested_from
        next  
      end
      next if period.effective_date >= requested_until
      results << { date_from: period_start, date_until: period_end, tariff: period.tariff }
      break if period.effective_date <= requested_from
      break if period.end_date < requested_from
    end
    results
  end

  def self.find_current_tariff(tariff_category, price_class)
    tariffs = Tariff.where('tariff_category = ? AND price_class = ? AND end_date = NULL', tariff_category, Tariff.price_classes[price_class])
  end

  def validate_effective_date_before_end_date
    if effective_date && end_date
      errors.add(:effective_date, "End date is before effective date") if end_date < effective_date
    end
  end

  def tariff_cannot_be_zero
    errors.add(:tariff, "Tariff must be greater than zero") unless tariff && tariff > 0
  end

  private

    def self.find_period_prices(accom_type ,requested_from, requested_until)
      tariffs = Tariff.where('accommodation_type_id = ?', accom_type.id) 
    end


end