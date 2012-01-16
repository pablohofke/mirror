require 'test_helper'

class RuleTest < ActiveSupport::TestCase
  
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
