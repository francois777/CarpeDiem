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

  def self.find_period_prices(accom_type ,eff_date, end_date)
    # if period overlaps two or more tariffs, the price must
    # be determined for each portion
    # Scenario 1:
    #     stored tariff end_date < requested start_start (don't include, next)
    #        - look for a later start_date
    #     stored tariff start_date > requested end_date (don't include)
    #        - stop looking for more tariffs
    #     requested start_date > stored tariff start_date and store end_date = nil (include)
    #        - stop looking got more tariffs
    #     requested start_date > stored tariff start_date and store end_date 
    #       OR
    #     requested end_date > stored tariff end_date
    #        - include and continue looking
    tariffs = Tariff.where('accommodation_type_id = ? AND (effective_date < ? OR end_date < ?)', accom_type.id, eff_date, end_date) 
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

end