require 'singleton'

class AppConfig
  include Singleton
  attr_reader :version, :designer, :designer_email, :child_discount_percentage, :child_age_range,
              :day_visitor_in_time, :day_visitor_out_time, :chalet_in_time, :chalet_out_time,
              :tents_and_caravans_checkin_time, :tents_and_caravans_checkout_time,
              :remain_on_premises_time
  attr_accessor :language

  def initialize
    @version = '1.0.0'
    @designer = 'Francois van der Hoven'
    @designer_email = 'francoisvanderhoven@gmail.com'
    @child_discount_percentage = 0.3
    @child_age_range = (6..12)
    @day_visitor_in_time = '08H00'
    @day_visitor_out_time = '17H30'
    @chalet_in_time = '11H00'
    @chalet_out_time = '17H30'
    @tents_and_caravans_checkin_time = '11H00'
    @tents_and_caravans_checkout_time = '17H00'
    @remain_on_premises_time = '17H30'
    @language = 'en'
  end
end