# Simula o ambiente de teste do Model User
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "validations" do
    
    assert_validation_on(:password, :presence, :length => {:within => 6..30})
  end
  
  # assert_validation_on
  test "assert_validation_on deve verificar a existencia dos kinds" do
    assert_validation_on(:email, :presence, :uniqueness, :email)
    begin
      assert_validation_on(:email, :presence, :uniqueness, :email, :length)
      fail 'should not get to here'
    rescue Exception => e
      assert_equal "email does not include length validator", e.message
    end
  end
  
  test "assert_validation_on deve confirma a existência das options dos attributes" do
    assert_validation_on(:email_confirmation, :presence, :confirmation, :on => :create)
  end
  
  
end
