require 'singleton'

class AppConfig
  include Singleton
  attr_reader :version, :designer, :designer_email, :child_discount, :child_age_range

  def initialize
    @version = '1.0.0'
    @designer = 'Francois van der Hoven'
    @designer_email = 'francoisvanderhoven@gmail.com'
    @child_discount = 0.3
    @child_age_range = (6..12)
    @day_visitor_in_time = '08H00'
    @day_visitor_out_time = '17H30'
    @chalet_in_time = '11H00'
    @chalet_out_time = '17H30'
    @tents_and_caravans_checkin_time = '11H00'
    @tents_and_caravans_checkout_time = '17H00'
  end
end