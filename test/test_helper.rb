# Configure Rails Environment
# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

# require 'rubygems'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
# require 'test/unit'

# $:.unshift File.expand_path("../../lib", __FILE__)
# require 'mirror'

class ActiveSupport::TestCase
  include Mirror
end

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
