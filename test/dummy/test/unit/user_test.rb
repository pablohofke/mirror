# Simula o ambiente de teste do Model User
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "validations" do
    # debugger
    assert_validation_on(:email, :presence, :uniqueness, :email)
    assert_validation_on(:email_confirmation, :presence, :confirmation, :on => :create)
    assert_validation_on(:password, :presence, :length => {:within => 6..30})
  end
end
