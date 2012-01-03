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
  
  # options
  
  # options :attribute, :kind
  test "deve retornar as options do validator quando passado o kind" do
    assert @uv.options(:email_confirmation,:presence)=={:on => :create}
    assert @uv.options(:email,:presence)=={}
  end
  
  # options :attribute, :kind
  test "deve retornas as options quando é passado somente o attribute" do
    assert @uv.options(:email_confirmation)=={:on => :create}
    assert @uv.options(:name)=={}
  end
  
  
  # has_options?
  
  test "has_options? :attribute" do
    assert @uv.has_options?(:password)
    assert !@uv.has_options?(:name)
  end
  
  test "has_options?(:attribute, :kind => :value)" do
    assert @uv.has_options?(:password, :kind => :length)
    assert !@uv.has_options?(:email, :kind => :presence)
  end
  
  test "has_options?(:attribute, :kind => :value, :options =>{...})" do
    assert @uv.has_options?(:password, {:kind => :length, :options => {:within => 6..30}})
    assert !@uv.has_options?(:password, {:kind =>:length, :options => {:within => 6..30, :on => :create}})
    assert !@uv.has_options?(:email, {:kind =>:length, :options => {:within => 6..30}})
  end
  
  test "has_options?(:attribute, :options => {...})" do
    assert @uv.has_options?(:email_confirmation, :options =>{:on => :create})
    assert !@uv.has_options?(:email, :options => {:on => :create})
  end
  
end