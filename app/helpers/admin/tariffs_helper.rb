module Admin::TariffsHelper

  def tariff_categories_for_select
    tariff_categories = {}
    tcs = I18n.t(:tariff_categories, scope: [:activerecord, :attributes, :tariff])
    tcs.each { |k,v| tariff_categories[v] = k.upcase }
    tariff_categories
  end

  def price_classes_for_select
    price_classes = {}
    pcs = I18n.t(:price_classes, scope: [:activerecord, :attributes, :tariff])
    pcs.each { |k,v| price_classes[v] = k.to_sym }
    price_classes    
  end

  def facility_categories_for_select
    facility_categories = {}
    fcs = I18n.t(:facility_categories, scope: [:activerecord, :attributes, :tariff])
    fcs.each { |k,v| facility_categories[v] = k.to_sym }
    facility_categories    
  end
end
