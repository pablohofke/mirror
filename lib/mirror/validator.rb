# Representa o validator
module Mirror
  class Validator
    
    include Mirror::Helpers
    
    attr_writer :model
    # Retorna as mensagens do validator
    attr_reader :message
    
    def initialize(model=nil)
      @model= model
    end
    
    # Retorna array com os tipos de validator
    # kinds :email
    def kinds(attribute)
      @model.validators_on(attribute).map(&:kind)
    end
    
    # Retorna as options do validator ou do attribute
    # options :email, :presence
    # options :email
    def options(attribute, kind=nil)
      validators=@model.validators_on(attribute)
      options={}
      if kind
        validators.find{|v| v.class.kind == kind}.instance_eval "@options"
      else
        validators.map(&:options).each{|o| options=options.merge o}
        options
      end
    end
    
    # Verifica a existencia do validator.kind para o attribute
    # has_kind? :email, :presence
    # has_kind? :email, [:presence,:uniqueness]
    def has_kind?(attribute,kinds)
      unless (no_included_kinds=Array(kinds) - kinds(attribute)).empty?
        @message="#{attribute.to_s} does not include #{sentence(no_included_kinds)} #{inflect("validator",no_included_kinds.size)}"
        false
      else
        true
      end
    end
    
    # Verifica existencias das options para o attribute
    # has_options?(:attribute)
    # has_options?(:attribute, :kind => :value)
    # has_options?(:attribute, :kind => :value, :options =>{...})
    # has_options?(:attribute, :options => {...})
    def has_options?(attribute,args={})
      kind=args[:kind] if args[:kind]
      options_to_check=normalize_options args[:options] if args[:options]
      current_options=options(attribute,kind) || {}
      diff_options=Array(options_to_check) - Array(current_options)
      if args=={} && current_options.empty?
        false & @message="#{attribute.to_s} does not have options"
      elsif kind && !options_to_check && current_options.empty?
        false & @message="#{attribute.to_s} does not have options for #{kind.to_s}"
      elsif kind && options_to_check && !diff_options.empty?
        false & @message="#{attribute.to_s} does not have #{sentence((options_to_check.keys - current_options.keys))} #{inflect("option",diff_options.size)} for #{kind.to_s}"
      elsif !kind && options_to_check && !diff_options.empty?
        false & @message="#{attribute.to_s} does not have #{sentence((options_to_check.keys - current_options.keys))} #{inflect("option",diff_options.size)}"
      else
        true
      end
     end
    
    protected
    
    # Reorganiza a hash options quando ela apresenta diferença na escrita e o que é passado
    def normalize_options(options)
      options.symbolize_keys!
      if range = (options.delete(:in) || options.delete(:within))
        raise ArgumentError, ":in and :within must be a Range" unless range.is_a?(Range)
        options[:minimum], options[:maximum] = range.begin, range.end
        options[:maximum] -= 1 if range.exclude_end?
      end
      options
    end
    
  end
end