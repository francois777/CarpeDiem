class Tariff < ActiveRecord::Base

  has_paper_trail on: [:create, :update, :destroy]

  VALID_TARIFF_CATEGORY = /\A[A-J][1-3]\z/
  TARIFF_CATEGORIES = I18n.t(:tariff_categories, scope: [:activerecord, :attributes, :tariff])
  PRICE_CLASSES = I18n.t(:price_classes, scope: [:activerecord, :attributes, :tariff])
  FACILITY_CATEGORIES = I18n.t(:facility_categories, scope: [:activerecord, :attributes, :tariff])

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
  enum facility_category: [:tent, :caravan, :chalet_small, :chalet_medium, :chalet_large, :ox_wagon, :day_visitor, :warrior_camp, :large_group]

  def self.adult_tariff(facility_cat, requested_from, requested_until, power_point_included = false)
    # puts "Tariff#adult_tariff"
    # puts "facility_cat: #{facility_cat}"
    cat = facility_cat.downcase.to_sym
    cat_inx = Tariff.facility_categories[cat]
    pri_inx = Tariff.price_classes[:normal_price]
    desired_tariffs = nil
    # puts "Facility category: #{facility_cat.inspect} - #{cat_inx.inspect}"
    case cat
    when :tent, :caravan
      # puts "Parameters for desired_tariffs:"
      # puts "facility_category: #{cat_inx}"
      # puts "with_power_points: #{power_point_included.to_s}"
      # puts "effective_date: #{requested_from.to_s}"
      # puts "price_class: #{pri_inx}"
      desired_tariffs = Tariff.where('facility_category = ? AND with_power_points = ? AND effective_date <= ? AND price_class = ?', 
        cat_inx, power_point_included, requested_from, pri_inx)
      # puts "Tariff found: #{Tariff.first.inspect}"
      # puts "Desired tariffs: #{desired_tariffs.inspect}"
    when :chalet_small, :chalet_medium, :chalet_large  
      desired_tariffs = Tariff.where('facility_category = ? AND effective_date >= ? AND price_class = ?', 
        cat_inx, requested_from, pri_inx)
    else
      nil  
    end  
    desired_tariffs[0].tariff
  end

  def self.find_prices(accom_type, requested_from, requested_until)
    # puts "Tariff.find_prices"
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