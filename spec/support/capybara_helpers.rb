module CapybaraHelpers

  RSpec.configure do |config|
    config.include CapybaraHelpers, :type => :request
  end
end