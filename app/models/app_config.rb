require 'singleton'

class AppConfig
  include Singleton
  attr_reader :version, :designer, :designer_email, :child_discount_percentage, :child_age_range,
              :day_visitor_in_time, :day_visitor_out_time, :chalet_in_time, :chalet_out_time,
              :tents_and_caravans_checkin_time, :tents_and_caravans_checkout_time,
              :remain_on_premises_time, :longest_event_duration, :longest_reservation,
              :max_occupants_per_camping_site, :max_occupants_per_small_chalet,
              :max_occupants_per_medium_chalet, :max_occupants_per_large_chalet,
              :in_season_periods, :promotion_periods
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
    @longest_event_duration = 14
    @longest_reservation = 14
    @max_occupants_per_camping_site = 6
    @max_occupants_per_small_chalet = 4
    @max_occupants_per_medium_chalet = 8
    @max_occupants_per_large_chalet = 14
    @in_season_periods = [ { period_start_month: 12, period_start_day: 1, duration_days: 40 },
                           { period_start_month: 3, period_start_day: 20, duration_days: 15 } ]
    @promotion_periods = [ { period_start_month: 2, period_start_day: 1, duration_days: 28 } ]
  end
end