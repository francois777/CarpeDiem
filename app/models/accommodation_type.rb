class AccommodationType < ActiveRecord::Base

  VALID_ACCOMMODATION_TYPE = /\A[A-K]\z/
  ACCOMMODATION_TYPES = I18n.t(:types, scope: [:activerecord, :attributes, :accommodation_types])

  has_many :tariffs

  validates :accom_type, presence: true,
                         uniqueness: true,
                         format: { with: VALID_ACCOMMODATION_TYPE }

  validates :description, presence: true

end