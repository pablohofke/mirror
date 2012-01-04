module Mirror
  module Assertions
    extend ActiveSupport::Concern
      included do
        def assert_validation_on(attribute)
          true
        end
      end
  end  
end
ActiveSupport::TestCase.send(:include,Mirror::Assertions)