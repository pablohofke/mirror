module Mirror
  module Assertions
    extend ActiveSupport::Concern
      included do
        def assert_validation_on(attribute,*args)
          result, message=[],[]
          av=Mirror::Validator.new self.class.name.gsub(/Test/, "").constantize
          kinds=get_options(:kinds,*args)
          attribute_options=get_options(:attribute_options,*args)
          kind_options=get_options(:kind_options,*args)
          result << av.has_kind?(attribute,kinds)
          result << av.has_options?(attribute,:options => attribute_options)
          kind_options.each do |k|
            # debugger if k[:kind]==:presence
            Rails.logger.debug "kind: #{k[:kind]} | options: #{k[:options]}"
            result << av.has_options?(attribute,:kind => k[:kind], :options => k[:options])
            message << av.message
          end
          message << av.message
          assert_block message.first do
            !result.include?(false)
          end
        end
      end
      
      protected
      
      def get_options(type,*args)
        validations_options=[:allow_nil,:allow_blank,:message,:on]
        case type
        when :kinds
          result=[]
          args.each do |a| 
            a=a.keys.first if a.is_a?(Hash)
            result << a unless validations_options.include?(a)
          end
        when :attribute_options
          result={}
          args.each{|a| if a.is_a?(Hash) && validations_options.include?(a.keys.first) then result=result.merge(a) end}
        when :kind_options
          result=[]
          formated_options={}
          args.each do |a|
            Rails.logger.debug "a: #{a}"
            if a.is_a?(Hash)
              a.each do |k,v|
                unless validations_options.include?(k)
                  formated_options[:kind],formated_options[:options]=k,a[k]
                  result << formated_options
                end
              end
            end
          end
        end
        result            
      end
  end  
end

ActiveSupport::TestCase.send(:include,Mirror::Assertions)