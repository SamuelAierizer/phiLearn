source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.0"
gem 'rails', '~> 7.0', '>= 7.0.2'
gem "puma", "~> 5.0"
gem "jsbundling-rails", "~> 0.1.0"

gem "turbo-rails", ">= 0.7.11"
gem "stimulus-rails", ">= 0.4.0"
gem "cssbundling-rails", ">= 0.1.0"
gem "jbuilder", "~> 2.7"

gem "redis", "~> 4.0"
gem 'pg', '~> 1.2', '>= 1.2.3'

gem 'devise', '~> 4.8', git: 'https://github.com/heartcombo/devise', ref: '8593801'
gem 'pundit', '~> 2.1'
gem 'nested_form', '~> 0.3.2'
gem 'activerecord-import', '~> 1.3'
gem "chartkick"

gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

gem "bootsnap", ">= 1.4.4", require: false

group :development, :test do
  gem "debug", ">= 1.0.0", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem "web-console", ">= 4.1.0"
end

group :test do
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem 'sprockets-rails', '~> 3.4', '>= 3.4.2'
gem "image_processing", ">= 1.2"