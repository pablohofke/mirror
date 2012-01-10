require 'test_helper'

class ValidatorTest < ActiveSupport::TestCase
  
  def setup
    @uv=Validator.new(User)
  end
  
  # kinds
  test "kinds deve retornar array com kind validators" do
    assert_equal [:presence,:uniqueness,:email],@uv.kinds(:email)
    assert_equal [:presence,:confirmation],@uv.kinds(:email_confirmation)
    assert_equal [:presence,:length],@uv.kinds(:password)
  end
  
  # has_kind?
  test "has_kind? deve validar os validadores padrão" do
    assert @uv.has_kind?(:email,:presence)
    assert @uv.has_kind?(:email,:uniqueness)
    assert @uv.has_kind?(:password,:presence)
    assert !@uv.has_kind?(:password,:uniqueness)
  end
  
  test "has_kind? deve validar vários validadores para o mesmo atributo" do
    assert @uv.has_kind?(:password,[:presence,:length])
    assert !@uv.has_kind?(:password,[:presence,:length,:uniqueness])
  end
  
  test "has_kind? deve validar mesmo que nem todos os validadores sejam contemplados" do
    assert @uv.has_kind?(:email,[:presence,:uniqueness])
  end
  
  test "has_kind? deve validar custom validators" do
    assert @uv.has_kind?(:email,:email)
    assert @uv.has_kind?(:email,[:email,:presence,:uniqueness])
  end
  
  test "has_kind? deve retornar a mensagem adequada" do
    @uv.has_kind?(:email,:presence)
    assert_nil @uv.message
    @uv.has_kind?(:password,:uniqueness)
    assert_equal "password does not include uniqueness validator",@uv.message
    @uv.has_kind?(:password,[:presence,:length,:uniqueness,:confirmation,:exclusion])
    assert_equal "password does not include uniqueness, confirmation and exclusion validators",@uv.message
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
  
  # has_options?(:attribute)
  test "has_options? deve aceitar somente o attribute e verificar se existe qualquer option" do
    assert @uv.has_options?(:password)
    assert !@uv.has_options?(:name)
  end
  
  # has_options?(:attribute, :kind => :validator_kind)
  test "has_options? deve verificar se existem options para um kind específico do attribute" do
    assert @uv.has_options?(:password, :kind => :length)
    assert !@uv.has_options?(:email, :kind => :presence)
  end
  
  # has_options?(:attribute, :kind => :value, :options =>{...})
  test "has_options? deve verificar as options específicas para o attribute e kind" do
    assert @uv.has_options?(:password, {:kind => :length, :options => {:within => 6..30}})
    assert !@uv.has_options?(:password, {:kind =>:length, :options => {:within => 6..30, :on => :create}})
    assert !@uv.has_options?(:email, {:kind =>:length, :options => {:within => 6..30}})
  end
  
  # has_options?(:attribute, :options => {...})
  test "has_options? deve verificar se existem options relacionadas ao attribute" do
    assert @uv.has_options?(:email_confirmation, :options =>{:on => :create})
    assert !@uv.has_options?(:email, :options => {:on => :create})
  end
  
  test "has_options? deve gerar as mensagens corretas" do
    assert @uv.has_options?(:password)
    assert_nil @uv.message
    @uv.has_options?(:name)
    assert_equal "name does not have options", @uv.message
    @uv.has_options?(:email, :kind => :presence)
    assert_equal "email does not have options for presence", @uv.message
    @uv.has_options?(:password, {:kind =>:length, :options => {:within => 6..30, :on => :create, :message => "Any message", :allow_blank => true}})
    assert_equal "password does not have on, message and allow_blank options for length", @uv.message
    @uv.has_options?(:password, {:kind =>:length, :options => {:within => 6..30, :on => :create}})
    assert_equal "password does not have on option for length", @uv.message
    @uv.has_options?(:email, :options => {:on => :create})
    assert_equal "email does not have on option", @uv.message
    @uv.has_options?(:email, :options => {:on => :create, :message => "Any message", :allow_blank => true})
    assert_equal "email does not have on, message and allow_blank options", @uv.message
  end
  
end