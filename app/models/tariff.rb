class Tariff < ActiveRecord::Base

  VALID_TARIFF_CATEGORY = /\A[A-J][1-3]\z/
  TARIFF_CATEGORIES = I18n.t(:tariff_categories, scope: [:activerecord, :attributes, :tariff]).map {|nme| nme[1]}

  validates :tariff_category, presence: true,
                              format: { with: VALID_TARIFF_CATEGORY },
                              uniqueness: { scope: :effective_date }
  validate :tariff, presence: true
                    
  validates :effective_date, presence: true          
  validate :validate_effective_date_before_end_date
  validate :tariff_cannot_be_zero

  default_scope { order('tariff_category ASC, effective_date DESC') }

  def validate_effective_date_before_end_date
    if effective_date && end_date
      errors.add(:effective_date, "End date is before effective date") if end_date < effective_date
    end
  end

  def tariff_cannot_be_zero
    errors.add(:tariff, "Tariff must be greater than zero") unless tariff && tariff > 0
  end

end