module Mirror
  module Validations
    def has_validator?(model,attribute,validator)
      kind_validators=[]
      if (class_validators=model.validators_on(attribute).map(&:class))
        class_validators.each{|v| kind_validators << v.kind}
        kind_validators.include?(validator)
      else
        false
      end
    end
    
    
  end
end