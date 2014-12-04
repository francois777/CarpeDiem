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
  end
end