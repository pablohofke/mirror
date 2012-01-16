module Mirror
  module Assertions
    extend ActiveSupport::Concern
      included do
        def assert_validation_on(attribute,*args)
          result, message=[],[]
          av=Mirror::Validator.new get_model
          kinds=get_validation_on_options(:kinds,*args)
          attribute_options=get_validation_on_options(:attribute_options,*args)
          kind_options=get_validation_on_options(:kind_options,*args)
          result << av.has_kind?(attribute,kinds)
          result << av.has_options?(attribute,:options => attribute_options)
          kind_options.each do |k|
            # debugger if k[:kind]==:presence
            Rails.logger.debug "kind: #{k[:kind]} | options: #{k[:options]}"
            result << av.has_options?(attribute,:kind => k[:kind], :options => k[:options])
            message << av.message
          end
          message << av.message
          assert_block (get_validation_on_options(:message,*args) || message.first) do
            !result.include?(false)
          end
        end
      end
      
      def assert_has_many(*args)
        aa=Mirror::Association.new get_model
        names=get_association_options(:names,*args)
        result= aa.has_many? *names
        assert_block (get_association_options(:message,*args) || aa.message) do
          result
        end
      end
      
      protected
      
      def get_model
        self.class.name.gsub(/Test/, "").constantize
      end
      
      def get_validation_on_options(type,*args)
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
        when :message
          result=args.last if args.last.is_a?(String)
        end
        result            
      end
      
      def get_association_options(type,*args)
        case type
        when :names
          if args.last.is_a?(String) then args.delete(args.last) else args end
        when :message
          args.last if args.last.is_a?(String)
        end
      end
      
  end  
end

ActiveSupport::TestCase.send(:include,Mirror::Assertions)