source 'https://rubygems.org'
source 'http://gemcutter.org'
source 'https://rails-assets.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.7'
# Use sqlite3 as the database for Active Record
gem 'haml-rails'
# Use SCSS for stylesheets
#gem 'sass-rails', '~> 4.0.3'
gem 'bootstrap-sass', '~>3.2.0'
gem 'rails-assets-bootstrap'
gem 'rails-assets-leaflet'
gem 'sass'
#  The gem 'sass' was added as a solution for these errors
#  Preparing app for Rails asset pipeline
#       Running: rake assets:precompile
#       Warning. Error encountered while saving cache 0d86f4464e29aec3f23db1b674c376d83192726b/custom.css.scssc: can't dump anonymous class #<Class:0x007f35edece738>
#       Warning. Error encountered while saving cache 2e9b983368d59fcf6e2bfae46ff2961a76bbbc95/bootstrap.scssc: can't dump anonymous class #<Class:0x007f35edece738>
#       Warning. Error encountered while saving cache 742f9d86bd66522b7017a14fe94674be6de9da87/bootstrap.scssc: can't dump anonymous class #<Class:0x007f35edece738>
#       I, [2014-12-08T09:07:44.018937 #666]  INFO -- : Writing /tmp/build_da67261288823c8a10d6a65e5a00c1a4/public/assets/application-396b5735fe52f122c2a4a99a0fa7cb0f.css
#       Asset precompilation completed (4.66s)
# http://stackoverflow.com/questions/22276991/heroku-error-encountered-while-saving-cache

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 2.3.0'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
group :development do
  gem 'spring'
  gem 'rails_12factor'
  gem 'pg'
  #  Use this gem to overcome problem: Error encountered 
  #  while saving cache , can't dump anonymous class
  gem 'sass-rails-source-maps'
end
gem 'rake', '~> 10.3.2'
gem 'paper_trail', '~> 3.0.6'

group :test, :development do
  gem 'rspec-rails'
  gem 'sqlite3'
  gem 'simplecov'
end

group :test do
  gem 'capybara', '~> 2.4.0'
  gem 'database_cleaner', github: 'bmabey/database_cleaner'
  gem 'factory_girl_rails'
end


# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

