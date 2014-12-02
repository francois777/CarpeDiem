module Admin::TariffsHelper

  def tariff_categories_for_select
    tariff_categories = {}
    tcs = I18n.t(:tariff_categories, scope: [:activerecord, :attributes, :tariff])
    tcs.each { |k,v| tariff_categories[v] = k.upcase }
    tariff_categories
  end
end
