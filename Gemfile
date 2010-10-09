# Edit this Gemfile to bundle your application's dependencies.
source 'http://gemcutter.org'


gem 'rails', '3.0.0'
gem 'activerecord', '3.0.0'
## Bundle edge rails:
# gem "rails", :git => "git://github.com/rails/rails.git"

gem "mysql"

## Bundle the gems you use:
# gem "bj"
# gem "hpricot", "0.6"
gem "sqlite3-ruby", :require => "sqlite3"
# gem "aws-s3", :require => "aws/s3"

## Bundle gems used only in certain environments:
# gem "rspec", :group => :test
# group :test do
#   gem "webrat"
# end
gem "authlogic", :git => "git://github.com/odorcicd/authlogic.git", :branch => "rails3"
gem 'aasm', :git => "git://github.com/rubyist/aasm.git"
gem 'will_paginate', '~> 3.0.pre2'
gem 'compass', ">= 0.10.1"
gem 'thinking-sphinx', :require => 'thinking_sphinx', :branch => 'rails3'
# gem 'paperclip', ">= 2.3.3"
gem 'paper_trail', ">= 1.5.2"
gem 'ruby-debug19', ">= 0.11.6"

group :development, :test do
	gem 'rspec-rails', ">= 2.0.0.beta.22"
	gem 'rspec'
	gem 'cucumber-rails'
	gem 'webrat'
	gem 'seed-fu'
end