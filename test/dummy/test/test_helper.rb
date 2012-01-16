ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
# require 'mirror/assertions'
require 'mirror'

class ActiveSupport::TestCase
  
  # Testa a falha de um assert_validation_on
  # assert_fail_validaton "assertion error message" do
  #   assert_validation_on(...)
  # end
  def assert_fail_assertion(expected_message,&block)
    begin
      block.call
      fail 'should not get to here'
    rescue Exception => e
      assert_equal expected_message, e.message
    end
  end
end