require 'test_helper'

class AssociationTest < ActiveSupport::TestCase
  
  def setup
    @ua=Association.new(User)
    @ra=Association.new(Rule)
  end
  
  test "has_many deve retonar um array com as associações" do
    assert_equal [:rules],@ua.has_many
    assert_not_equal [:rules,:teams],@ua.has_many
  end
  
  test "belongs_to deve retornar uma array com as associações" do
    assert_equal [:user],@ra.belongs_to
    assert_not_equal [:user,:department],@ra.belongs_to
  end
  
  # has_many?
  test "has_many? deve verificar se existem associções" do
    assert @ua.has_many?(:rules)
    assert !@ua.has_many?(:rules,:posts)
  end
  
  test "has_many? deve passar as mensagens corretas" do
    @ua.has_many?(:teams)
    assert_equal "User has no has_many association with teams", @ua.message
    @ua.has_many?(:hearts, :departaments, :teams)
    assert_equal "User has no has_many associations with hearts, departaments and teams", @ua.message
  end
  
  # belongs_to?
  test "belongs_to? deve verificar se existem associações" do
    assert @ra.belongs_to?(:user)
    assert !@ra.belongs_to?(:user,:department)
  end
  
  test "belongs_to? deve passar as mensagens corretas" do
    @ra.belongs_to?(:departament)
    assert_equal "Rule has no belongs_to association with departament", @ra.message
    @ra.belongs_to?(:post, :departament, :team)
    assert_equal "Rule has no belongs_to associations with post, departament and team", @ra.message
  end
  
end