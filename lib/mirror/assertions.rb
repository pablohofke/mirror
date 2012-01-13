module Mirror
  module Assertions
    extend ActiveSupport::Concern
      included do
        def assert_validation_on(attribute,*args)
          result, message=[],[]
          av=Mirror::Validator.new self.class.name.gsub(/Test/, "").constantize
          kinds=get_options(:kinds,*args)
          # Rails.logger.debug kinds
          attribute_options=get_options(:attribute_options,*args)
          result << av.has_kind?(attribute,kinds)
          result << av.has_options?(attribute,:options => attribute_options)
          # debugger if result.include?(false)
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
          args.each do |a| 
            a=a.keys.first if a.is_a?(Hash)
            Rails.logger.debug a
            result << a unless validations_options.include?(a)
          end
        when :attribute_options
          
          result={}
          args.each do |a| 
            # debugger
            if a.is_a?(Hash) && validations_options.include?(a.keys.first) then result=result.merge(a) end
            end
        end
        result            
      end
  end  
end
ActiveSupport::TestCase.send(:include,Mirror::Assertions)