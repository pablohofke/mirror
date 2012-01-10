require 'test_helper'
require 'mirror/helpers'

class ValidatorTest < ActiveSupport::TestCase
  
  include Mirror::Helpers
  
  # sentence(array)
  test "sentence deve gerar uma sentená correta" do
    assert_equal "1, 2 and 3", sentence([1,2,3])
    assert_equal "orange, banana and avocado", sentence(["orange","banana","avocado"])
  end
  
  # inflect(word,count)
  test "inflect deve retornar a inflecção da palavra de acordo com o count" do
    assert_equal "oranges", inflect("orange",2)
    assert_equal "banana", inflect("banana",1)
  end
  
end