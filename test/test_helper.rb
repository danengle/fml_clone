<<<<<<< HEAD
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
=======
require 'ostruct'
require 'rubygems'

begin
  gem 'minitest'
rescue Gem::LoadError
  puts 'minitest gem not found'
end

begin
  require 'minitest/autorun'
  puts 'using minitest'
rescue LoadError
  require 'test/unit'
  puts 'using test/unit'
end

require 'rr'
require 'shoulda'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end

begin
  require 'ruby-debug'
  Debugger.start
rescue LoadError
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'aasm'
>>>>>>> 690137c5e5eb68ea36edbb029fd22a043fe63de5
