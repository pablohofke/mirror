require 'test_helper'
# require 'active_record'

class ValidatorTest < ActiveSupport::TestCase
  
  def setup
    @uv=Validator.new(User)
  end
  
  # has_kind
  test "deve validar os validadores padrão" do
    assert @uv.has_kind?(:email,:presence)
    assert @uv.has_kind?(:email,:uniqueness)
    assert @uv.has_kind?(:password,:presence)
    assert !@uv.has_kind?(:password,:uniqueness)
  end
  
  test "deve validar vários validadores para o mesmo atributo" do
    assert @uv.has_kind?(:password,[:presence,:length])
    assert !@uv.has_kind?(:password,[:presence,:length,:uniqueness])
  end
  
  test "deve validar mesmo que nem todos os validadores sejam contemplados" do
    assert @uv.has_kind?(:email,[:presence,:uniqueness])
  end
  
  test "deve validar custom validators" do
    assert @uv.has_kind?(:email,:email)
    assert @uv.has_kind?(:email,[:email,:presence,:uniqueness])
  end
end