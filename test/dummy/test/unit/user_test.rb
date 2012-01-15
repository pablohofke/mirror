# Simula o ambiente de teste do Model User
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  # assert_association
  test "assert_association deve validar has_many" do
    assert_association(:has_many, :rules)
  end
  
  # assert_validation_on
  test "assert_validation_on deve verificar a existencia dos kinds" do
    assert_validation_on(:email, :presence, :uniqueness, :email)
    assert_fail_validation "email does not include length validator" do 
      assert_validation_on(:email, :presence, :uniqueness, :email, :length)
    end
  end
  
  test "assert_validation_on deve confirma a existência das options dos attributes" do
    assert_validation_on(:email_confirmation, :presence, :confirmation, :on => :create)
    assert_fail_validation "email_confirmation does not have allow_nil option" do
      assert_validation_on(:email_confirmation, :presence, :confirmation, :on => :create, :allow_nil => true)
    end
  end

  test "assert_validation_on deve verificar a existência de options para validators kinds" do
    assert_validation_on(:password, :presence, :length => {:within => 6..30})
    assert_fail_validation "password does not have on option for presence" do
      assert_validation_on(:password, :presence => {:on => :create}, :length => {:within => 6..30})
    end
  end
  
  test "assert_validation deve aceitar mensagens personalizadas" do
    assert_fail_validation "email sem presence" do 
      assert_validation_on(:email, :presence, :uniqueness, :email, :length, "email sem presence")
    end
    assert_fail_validation "email_confirmation sem allow_nil" do 
      assert_validation_on(:email_confirmation, :presence, :confirmation, {:on => :create, :allow_nil => true}, "email_confirmation sem allow_nil")
    end
    assert_fail_validation "sem on para presence" do 
      assert_validation_on(:password, {:presence => {:on => :create}, :length => {:within => 6..30}}, "sem on para presence")
    end
    
  end
  
end
