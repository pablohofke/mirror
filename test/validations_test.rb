require 'test_helper'
# require 'active_record'

class ValidationsTest < ActiveSupport::TestCase
  include Mirror::Validations
  
  test "deve validar :presence" do
    assert has_validator?(User, :email, :presence)
    assert has_validator?(User, :password, :presence)
    assert !has_validator?(User, :name, :presence)
  end
  
  test "deve validar :unequeness" do
    assert has_validator?(User, :email, :uniqueness)
    assert !has_validator?(User, :password, :uniqueness)
  end
  
  test "deve validar vários validators" do
    assert has_validator?(User, :email, [:presence,:uniqueness])
    assert !has_validator?(User, :name, [:presence,:uniqueness])
    assert !has_validator?(User, :password, [:presence,:uniqueness])
  end
end