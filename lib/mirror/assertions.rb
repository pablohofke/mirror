module Mirror
  module Assertions
    extend ActiveSupport::Concern
      included do
        
        # Verifica se foi definida a validação para o attribute específico
        # assert_validation_on(:attribute, :kind, :kind...)
        # assert_validation_on(:attribute, :kind, kind...,:option => :value, :option => :value...)
        # assert_validation_on(:attribute, :kind, :kind => :option...)
        # Para passar mensagem, sempre coloque no final
        # assert_validation_on(:attribute, :kind, :kind..., message)
        def assert_validation_on(attribute,*args)
          result, message=[],[]
          av=Mirror::Validator.new get_model
          kinds=get_validation_on_options(:kinds,*args)
          attribute_options=get_validation_on_options(:attribute_options,*args)
          kind_options=get_validation_on_options(:kind_options,*args)
          result << av.has_kind?(attribute,kinds)
          result << av.has_options?(attribute,:options => attribute_options)
          kind_options.each do |k|
            result << av.has_options?(attribute,:kind => k[:kind], :options => k[:options])
            message << av.message
          end
          message << av.message
          assert_block (get_validation_on_options(:message,*args) || message.first) do
            !result.include?(false)
          end
        end
      end
      
      # Verifica se existe o tipo de relação no model
      # assert_has_many :models, :models...[, message]
      def assert_has_many(*args)
        assert_association(:has_many,*args)
      end

      # Verifica se xiste o tipo de relação no model
      # assert_belongs_to :models, :models...[, message]
      def assert_belongs_to(*args)
        assert_association(:belongs_to,*args)
      end
      
      # Verifica se está definido attr_accessible para os attributes
      # assert_attr_accessible :attribute, :attribute..[, "message"]
      def assert_attr_accessible(*args)
        assert_attr_protection :attr_accessible, *args
      end
      
      # Verifica se está definido attr_protected para os attributes
      # assert_attr_protected :attribute, :attribute..[, "message"]
      def assert_attr_protected(*args)
        assert_attr_protection :attr_protected, *args
      end
      
      protected
      
      # Obtem o model do teste
      def get_model
        self.class.name.gsub(/Test/, "").constantize
      end
      
      # Obtem as options para assert_validation_on
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
            if a.is_a?(Hash)
              a.each do |k,v|
                unless validations_options.include?(k)
                  formated_options[:kind],formated_options[:options]=k,a[k]
                  result << formated_options.dup
                end
              end
            end
          end
        when :message
          result=args.last if args.last.is_a?(String)
        end
        result            
      end
      
      # Método genérico para ser usado com assert_has_many e assert_block
      # assert_association :has_many,*args
      # assert_association :belongs_to,*args
      def assert_association(type,*args)
        aa=Mirror::Association.new get_model
        names=get_options *args
        result= aa.send((type.to_s + "?").to_sym, *names)
        assert_block (get_message(*args) || aa.message) do
          result
        end
        
      end
      
      # Utilizado para verificar assert_attr_aaccessible e assert_attr_accessible
      # assert_attr_protection :attr_accessible, *args
      # assert_attr_protection :attr_protected, *args
      def assert_attr_protection(type,*args)
        amas=Mirror::MassAssignmentSecurity.new get_model
        method= case type
                when :attr_accessible then :accessible_attributes? 
                when :attr_protected then :protected_attributes? 
                end
        result=amas.send(method, *(get_options *args))
        assert_block (get_message(*args) || amas.message) do
          result
        end
      end
      
      # Obtem as custom mensagens dos args
      def get_message(*args)
        args.last if args.last.is_a?(String)
      end
      
      # Obtem as options removendo a custom message
      def get_options(*args)
        if args.last.is_a?(String) then args.delete(args.last) else args end
      end
        
  end  
end

ActiveSupport::TestCase.send(:include,Mirror::Assertions)