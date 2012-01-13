# Simula o ambiente de teste do Model User
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  # test "validations" do
  #     
  #     assert_validation_on(:password, :presence, :length => {:within => 6..30})
  #   end
  
  # assert_validation_on
  test "assert_validation_on deve verificar a existencia dos kinds" do
    assert_validation_on(:email, :presence, :uniqueness, :email)
    assert_fail_validaton "email does not include length validator" do 
      assert_validation_on(:email, :presence, :uniqueness, :email, :length)
    end
  end
  
  test "assert_validation_on deve confirma a existência das options dos attributes" do
    assert_validation_on(:email_confirmation, :presence, :confirmation, :on => :create)
    assert_fail_validaton "email_confirmation does not have allow_nil option" do
      assert_validation_on(:email_confirmation, :presence, :confirmation, :on => :create, :allow_nil => true)
    end
  end
  
  
end
