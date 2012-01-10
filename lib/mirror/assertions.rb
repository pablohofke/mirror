module Mirror
  module Assertions
    extend ActiveSupport::Concern
      included do
        def assert_validation_on(attribute,*args)
          # av=Mirror::Validator.new self.class.name.gsub(/Test/, "").constantize
          debugger
          assert true
        end
      end
      
      # def get_options(type)
      #         
      #       end
  end  
end
ActiveSupport::TestCase.send(:include,Mirror::Assertions)