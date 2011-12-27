# Representa o validator
module Mirror
  class Validator
    attr_accessor :model
    
    def initialize(model=nil)
      @model= model
    end
    
    # Verifica a existencia do validator.kind para o attribute
    # has_kind? :email, :presence
    # has_kind? :email, [:presence,:uniqueness]
    def has_kind?(attribute,kinds)
      kinds_to_check,result=[],[]
      kinds_to_check << kinds
      kinds_to_check.flatten!
      kinds_to_check.each{|k| result << check_kind(attribute,k)}
      !result.include?(false)
    end
    
    protected
    # Verifica se existe o validator kind para o attribute 
    def check_kind(attribute,kind)
      kind_validators=[]
      if (class_validators=@model.validators_on(attribute).map(&:class))
        class_validators.each{|v| kind_validators << v.kind}
        kind_validators.include?(kind)
      else
        false
      end
    end
    
  end
end