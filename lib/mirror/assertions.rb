module Mirror
  module Assertions
    extend ActiveSupport::Concern
      included do
        def assert_validation_on(attribute,*args)
          result, message=[],[]
          av=Mirror::Validator.new self.class.name.gsub(/Test/, "").constantize
          kinds=get_options(:kinds,*args)
          options=get_options(:options,*args)
          # debugger
          result << av.has_kind?(attribute,kinds)
          result << av.has_options?(attribute,options)
          message << av.message
          assert_block message.first do
            !result.include?(false)
          end
        end
      end
      
      def get_options(type,*args)
        validations_options=[:allow_nil,:allow_blank,:message,:on]
        case type
        when :kinds
          result=[]
          args.each{|a| result << a unless validations_options.include?(a)}
        when :options
          result={}
          args.each{|a| if a.is_a?(Hash) then result=result.merge(a) end}
        end
        result            
      end
  end  
end
ActiveSupport::TestCase.send(:include,Mirror::Assertions)