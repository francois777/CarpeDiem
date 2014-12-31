class AccommodationType < ActiveRecord::Base

  has_paper_trail on: [:update, :destroy]

  VALID_ACCOMMODATION_TYPE = /\A[A-K]\z/
  ACCOMMODATION_TYPES = I18n.t(:types, scope: [:activerecord, :attributes, :accommodation_types])
  ACCOMMODATION_NAMES = { tent_site_without_power: 'A',
                          tent_site_with_power: 'B',
                          caravan_site_without_power: 'C',
                          caravan_site_with_power: 'D',
                          day_visitor: 'E',
                          chalet_small: 'F',
                          chalet_medium: 'G',
                          chalet_large: 'H',
                          king_and_warrior_camps: 'I',
                          group_tariff_budget: 'J',
                          group_tariff_with_meals: 'K'
                        }

  has_many :tariffs

  validates :accom_type, presence: true,
                         uniqueness: true,
                         format: { with: VALID_ACCOMMODATION_TYPE }

  validates :description, presence: true
  default_scope { order('accom_type ASC') }
  scope :promotions, -> { where('show_promotion = ?', true) }
  scope :in_season_prices, -> { where('show_in_season_price = ?', true) }
  scope :normal_prices, -> { where('show_normal_price = ?', true) }

  def self.to_hash
    hash = {}
    AccommodationType.all.each do |at|
      hash[at.accom_type] = at.attributes
    end
    hash
  end

end