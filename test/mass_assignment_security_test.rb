# encoding: utf-8
require 'test_helper'

class MassAssignmentSecurityTest < ActiveSupport::TestCase
  
  def setup
    @umas=MassAssignmentSecurity.new(User)
    @rmas=MassAssignmentSecurity.new(Rule)
  end
  
  # accessible_attributes?
  test "accessible_attributes? deve verificar se os attributos passados são acessíveis" do
    assert @umas.accessible_attributes?(:email, :email_confirmation, :password)
    assert !@umas.accessible_attributes?(:email, :email_confirmation, :password, :my_pet)
  end
  
  test "accessible_attributes? deve levar em conta as rules para verificar os attributes" do
    assert @umas.accessible_attributes? :email, :email_confirmation, :password, :rating, :as => :admin
    assert !@umas.accessible_attributes?(:email, :email_confirmation, :password, :rating, :as => :blog_user)
  end
  
  test "accessible_attributes? deve gerar a mensagem correta" do
    @umas.accessible_attributes? :email, :email_confirmation, :password, :my_pet
    assert_equal "my_pet is not accessible", @umas.message
    @umas.accessible_attributes? :email, :email_confirmation, :password, :my_pet, :my_mother, :my_father
    assert_equal "my_pet, my_mother and my_father are not accessible", @umas.message
    @umas.accessible_attributes? :email, :email_confirmation, :password, :rating, :as => :blog_user
    assert_equal "email, email_confirmation, password and rating are not accessible for blog_user", @umas.message
  end
  
  # protected_attributes?
  test "protected_attributes? deve verificar se os attributos passados são protegidos" do
    assert @rmas.protected_attributes? :name
    assert !@rmas.protected_attributes?(:is_admin)
  end
  
  test "protected_attributes? deve levar em conta as rules para verificar os attributes" do
    assert @rmas.protected_attributes? :name, :as => :default
    assert !@rmas.protected_attributes?(:name, :as => :admin)
  end
  
  test "protected_attributes? deve gerar a mensagem correta" do
    @rmas.protected_attributes? :is_admin
    assert_equal "is_admin is not protected", @rmas.message
    @rmas.protected_attributes? :is_admin, :is_manager, :is_ceo
    assert_equal "is_admin, is_manager and is_ceo are not protected", @rmas.message
    @rmas.protected_attributes? :name, :as => :admin
    assert_equal "name is not protected for admin", @rmas.message
  end
  
end