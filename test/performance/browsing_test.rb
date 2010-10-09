require 'test_helper'
require 'rails/performance_test_help'

# Profiling results for each test method are written to tmp/performance.
class BrowsingTest < ActionController::PerformanceTest
  def setup
    login_as(:dan)
  end
  
  def test_homepage
    get '/admin/posts'
  end
end
