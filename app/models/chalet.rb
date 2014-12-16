class Chalet < ActiveRecord::Base

  STYLE_CLASSES = I18n.t(:style_classes).each_with_index.map { |iType| iType[0].to_s }
  CHALET_NAMES = I18n.t(:chalet_names).each_with_index.map { |iType| iType[0].to_s }

  validates :name, presence: true, 
                    length: { minimum: 3, maximum: 20 }
  validates_uniqueness_of :name
  validates :location_code, presence: true, 
                    length: { minimum: 2, maximum: 5 }
  validates_uniqueness_of :location_code

  enum style_class: STYLE_CLASSES
end