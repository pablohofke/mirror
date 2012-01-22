# Simula o ambiente de teste do Model User
require 'model_test_helper'

class UserTest < ActiveSupport::TestCase
  
  # assert_attr_accessible
  test "assert_attr_accessible" do
    assert_attr_accessible :email, :email_confirmation, :password
    assert_fail_assertion "my_pet is not accessible" do
      assert_attr_accessible :email, :email_confirmation, :password, :my_pet
    end
  end
  
  test "assert_attr_accessible deve aceitar as rules" do
    assert_attr_accessible :email, :email_confirmation, :password, :rating, :as => :admin
    assert_fail_assertion "email, email_confirmation, password and rating are not accessible for blog_user" do
      assert_attr_accessible :email, :email_confirmation, :password, :rating, :as => :blog_user
    end
  end
  
  test "assert_attr_accessible deve aceitar custm messages" do
    assert_fail_assertion "no access to my_pet" do
      assert_attr_accessible :email, :email_confirmation, :password, :my_pet, "no access to my_pet"
    end
  end
  
  # assert_has_many
  test "assert_has_many" do
    assert_has_many :rules
    assert_fail_assertion "User has no has_many association with teams" do
      assert_has_many :teams
    end
  end
  
  test "assert_has_many deve apresentar a mensagem customizada" do
    assert_fail_assertion "no has_many for teams" do
      assert_has_many :teams, "no has_many for teams"
    end
  end
  
  # assert_validation_on
  test "assert_validation_on deve verificar a existencia dos kinds" do
    assert_validation_on(:email, :presence, :uniqueness, :email)
    assert_fail_assertion "email does not include length validator" do 
      assert_validation_on(:email, :presence, :uniqueness, :email, :length)
    end
  end
  
  test "assert_validation_on deve confirma a existência das options dos attributes" do
    assert_validation_on(:email_confirmation, :presence, :confirmation, :on => :create)
    assert_fail_assertion "email_confirmation does not have allow_nil option" do
      assert_validation_on(:email_confirmation, :presence, :confirmation, :on => :create, :allow_nil => true)
    end
  end

  test "assert_validation_on deve verificar a existência de options para validators kinds" do
    assert_validation_on(:password, :presence, :length => {:within => 6..30})
    assert_fail_assertion "password does not have on option for presence" do
      assert_validation_on(:password, :presence => {:on => :create}, :length => {:within => 6..30})
    end
  end
  
  test "assert_validation deve aceitar mensagens personalizadas" do
    assert_fail_assertion "email sem presence" do 
      assert_validation_on(:email, :presence, :uniqueness, :email, :length, "email sem presence")
    end
    assert_fail_assertion "email_confirmation sem allow_nil" do 
      assert_validation_on(:email_confirmation, :presence, :confirmation, {:on => :create, :allow_nil => true}, "email_confirmation sem allow_nil")
    end
    assert_fail_assertion "sem on para presence" do 
      assert_validation_on(:password, {:presence => {:on => :create}, :length => {:within => 6..30}}, "sem on para presence")
    end
    
  end
  
end
