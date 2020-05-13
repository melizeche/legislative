source 'https://rubygems.org'

ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.0'

# Use Devise for user authentication
gem 'devise', :git => 'git://github.com/plataformatec/devise.git', :ref => '49aebde'

# Database
gem 'sqlite3'

# Template Engine
gem 'haml'
gem 'haml-rails', '>= 0.5.3', :group => :development

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.5'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 2.5.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.1'

# Use jquery as the JavaScript library
gem 'jquery-rails', '>= 4.0.1'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '>= 2.2.1'

# bcrypt-ruby is a Ruby binding for the OpenBSD bcrypt() password hashing algorithm
gem 'bcrypt-ruby', :require => 'bcrypt'

# An interface to the ImageMagick and GraphicsMagick image processing libraries
gem 'rmagick'

# Adam Shaw's fullcalendar jquery plugin
gem 'fullcalendar-rails'

# Support to XLS export
gem 'ekuseru', '>= 0.3.10'

# Support for localization
gem 'rails-i18n', '~> 4.0.2'
gem 'route_translator'

# Caching
gem 'actionpack-page_caching', '>= 1.1.0'
gem 'actionpack-action_caching', '>= 1.2.0'

# Clean ruby syntax for writing and deploying cron jobs (for rvm)
gem 'whenever', :git => 'https://github.com/Insomniware/whenever.git', :require => false
#gem 'whenever', :require => false #for non rvm

group :production do
  gem 'mysql'
  gem 'newrelic_rpm'
end

group :development do
  gem 'thin', '>= 1.6.2'
  gem 'better_errors'
  gem 'quiet_assets', '>= 1.0.2'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'coveralls', require: false
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
end

group :test do
  gem 'rspec-rails', '>= 2.14.2'
  gem 'factory_girl_rails', '>= 4.4.1'
  gem 'webmock'
end

# POPLUS integration
gem 'roar', '0.11.19'
gem 'roar-rails', '0.1.0'
gem 'faraday', '0.8.1'
gem 'billit_representers', '0.9.3'
gem 'popit_representers', '0.0.15'
gem 'writeit-rails', :git => 'git://github.com/ciudadanointeligente/writeit-rails.git'

gem 'httparty', '>= 0.14.0'
gem 'json', '>= 2.3.0'
gem 'protected_attributes'
gem 'rake', '10.1.1'
