require 'model_test_helper'

class RuleTest < ActiveSupport::TestCase
  
  # assert_attr_protected
   test "assert_attr_protected" do
     assert_attr_protected :name
     assert_fail_assertion "is_admin is not protected" do
       assert_attr_protected :is_admin
     end
   end

   test "assert_attr_protected deve aceitar as rules" do
     assert_attr_protected :name, :as => :default
     assert_fail_assertion "name is not protected for admin" do
       assert_attr_protected :name, :as => :admin
     end
   end

   test "assert_attr_protected deve aceitar custm messages" do
     assert_fail_assertion "no protection for is_admin" do
       assert_attr_protected :is_admin, "no protection for is_admin"
     end
   end
  
  # assert_belongs_to
  test "assert_belongs_to" do
    assert_belongs_to :user
    assert_fail_assertion "Rule has no belongs_to association with team" do
      assert_belongs_to :team
    end
  end
  
  test "assert_belongs_to deve apresentar a mensagem customizada" do
    assert_fail_assertion "no belongs_to for teams" do
      assert_belongs_to :team, "no belongs_to for teams"
    end
  end
  
end
